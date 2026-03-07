#!/usr/bin/env python3
"""Auto-classify and move INBOX messages to related folders via IMAP."""

from __future__ import annotations

import argparse
import base64
import imaplib
import json
import sys
from dataclasses import dataclass
from email import message_from_bytes
from email.header import decode_header
from email.utils import parseaddr
from pathlib import Path
from typing import Callable


@dataclass(frozen=True)
class MailContext:
    uid: str
    from_addr: str
    subject: str
    content_preview: str
    search_text: str


@dataclass(frozen=True)
class Rule:
    name: str
    target_mailbox: str
    predicate: Callable[[MailContext], bool]


def _decode_mime_header(raw_value: str | None) -> str:
    if not raw_value:
        return ""
    chunks: list[str] = []
    for part, charset in decode_header(raw_value):
        if isinstance(part, bytes):
            enc = charset or "utf-8"
            try:
                chunks.append(part.decode(enc, errors="replace"))
            except LookupError:
                chunks.append(part.decode("utf-8", errors="replace"))
        else:
            chunks.append(part)
    return "".join(chunks).strip()


def _normalize(value: str) -> str:
    return (value or "").strip().lower()


def _contains_any(haystack: str, needles: list[str]) -> bool:
    return any(needle in haystack for needle in needles)


def _default_rules() -> list[Rule]:
    return [
        Rule(
            name="shi-project-content",
            target_mailbox="프로젝트.SHI",
            predicate=lambda ctx: (
                _contains_any(ctx.from_addr, ["samsumg", "samsung"])
                or _contains_any(
                    ctx.search_text,
                    [
                        "삼성중공업",
                        "samsung heavy industries",
                        "samsung heavy",
                        "shi)",
                        "(shi",
                        "[shi",
                        "visit.shi@",
                    ],
                )
            ),
        ),
        Rule(
            name="gov-project-d25003-content",
            target_mailbox="연구소.과제발굴.d25003",
            predicate=lambda ctx: _contains_any(
                ctx.search_text,
                [
                    "d25003",
                    "소부재",
                    "정부과제",
                    "정부 과제",
                    "국책과제",
                    "과제발굴",
                    "소부재 정부과제",
                ],
            ),
        ),
        Rule(
            name="exosphere-security-alert",
            target_mailbox="Trash",
            predicate=lambda ctx: (
                ctx.from_addr == "no-reply@exosp.com"
                or _contains_any(
                    _normalize(ctx.subject),
                    ["[보안알림]", "pc가 로그인 상태로 변경되었습니다"],
                )
            ),
        ),
        Rule(
            name="nate-bounce-notice",
            target_mailbox="Trash",
            predicate=lambda ctx: (
                ctx.from_addr == "mailer-daemon@nate.com"
                or _contains_any(_normalize(ctx.subject), ["[발송실패안내]"])
            ),
        ),
        Rule(
            name="advertisement-mail",
            target_mailbox="Trash",
            predicate=lambda ctx: _contains_any(
                _normalize(ctx.subject),
                [
                    "(광고)",
                    "[광고]",
                    "광고]",
                    "광고)",
                ],
            ),
        ),
        Rule(
            name="weekly-report",
            target_mailbox="연구소",
            predicate=lambda ctx: _contains_any(_normalize(ctx.subject), ["주간업무보고"]),
        ),
        Rule(
            name="abb-shi",
            target_mailbox="프로젝트.SHI",
            predicate=lambda ctx: (
                ctx.from_addr.endswith("@kr.abb.com")
                or _contains_any(ctx.from_addr, ["samsumg", "samsung"])
                or _contains_any(_normalize(ctx.subject), ["anti spatter"])
            ),
        ),
    ]


def _load_password(path: Path) -> str:
    raw = path.read_text(encoding="utf-8")
    password = raw.strip("\r\n")
    if not password:
        raise ValueError("password is empty")
    return password


def _imap_utf7_encode(mailbox: str) -> str:
    """Encode mailbox name to IMAP modified UTF-7 (ASCII-safe)."""
    out: list[str] = []
    buff: list[str] = []

    def flush_buff() -> None:
        if not buff:
            return
        chunk = "".join(buff).encode("utf-16-be")
        b64 = base64.b64encode(chunk).decode("ascii").rstrip("=").replace("/", ",")
        out.append(f"&{b64}-")
        buff.clear()

    for ch in mailbox:
        code = ord(ch)
        if 0x20 <= code <= 0x7E:
            flush_buff()
            if ch == "&":
                out.append("&-")
            else:
                out.append(ch)
        else:
            buff.append(ch)
    flush_buff()
    return "".join(out)


def _extract_header_bytes(fetch_data: list[object]) -> bytes:
    for item in fetch_data:
        if isinstance(item, tuple) and len(item) >= 2 and isinstance(item[1], bytes):
            return item[1]
    return b""


def _decode_body_blob(raw: bytes) -> str:
    if not raw:
        return ""
    for encoding in ("utf-8", "cp949", "euc-kr"):
        try:
            return raw.decode(encoding)
        except UnicodeDecodeError:
            continue
    return raw.decode("latin1", errors="replace")


def _compact_whitespace(text: str) -> str:
    return " ".join(text.split())


def _fetch_body_preview(conn: imaplib.IMAP4_SSL, uid: str) -> str:
    # Partial fetch keeps classification lightweight even for large emails.
    typ, data = conn.uid("FETCH", uid, "(BODY.PEEK[TEXT]<0.8192>)")
    if typ != "OK":
        return ""
    body_bytes = _extract_header_bytes(data if isinstance(data, list) else [])
    return _compact_whitespace(_decode_body_blob(body_bytes))


def _fetch_context(conn: imaplib.IMAP4_SSL, uid: str) -> MailContext:
    typ, data = conn.uid("FETCH", uid, "(BODY.PEEK[HEADER.FIELDS (FROM SUBJECT TO CC DATE)])")
    if typ != "OK":
        return MailContext(uid=uid, from_addr="", subject="", content_preview="", search_text="")

    header_bytes = _extract_header_bytes(data if isinstance(data, list) else [])
    msg = message_from_bytes(header_bytes)
    from_addr = _normalize(parseaddr(msg.get("From", ""))[1])
    subject = _decode_mime_header(msg.get("Subject", ""))
    content_preview = _fetch_body_preview(conn, uid)
    search_text = _normalize(" ".join([from_addr, subject, content_preview]))
    return MailContext(
        uid=uid,
        from_addr=from_addr,
        subject=subject,
        content_preview=content_preview,
        search_text=search_text,
    )


def _ensure_mailboxes(conn: imaplib.IMAP4_SSL, mailboxes: set[str]) -> set[str]:
    available: set[str] = set()
    for mailbox in sorted(mailboxes):
        encoded = _imap_utf7_encode(mailbox)
        typ, data = conn.list("", f"\"{encoded}\"")
        if typ == "OK" and data and data[0]:
            available.add(mailbox)
    return available


def _match_rule(ctx: MailContext, rules: list[Rule]) -> Rule | None:
    for rule in rules:
        if rule.predicate(ctx):
            return rule
    return None


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--imap-host", default="gw.spsystems.co.kr")
    parser.add_argument("--imap-port", type=int, default=993)
    parser.add_argument("--user", default="taeyang@spsystems.kr")
    parser.add_argument(
        "--pass-file",
        default="/home/qwe/.config/codex-secrets/spsmail.pass",
        help="Path to a file containing IMAP password",
    )
    parser.add_argument("--inbox", default="INBOX")
    parser.add_argument("--limit", type=int, default=0, help="0 means all messages")
    parser.add_argument(
        "--apply",
        action="store_true",
        help="Apply move operation. If omitted, run as dry-run.",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    pass_file = Path(args.pass_file).expanduser()
    password = _load_password(pass_file)

    report: dict[str, object] = {
        "mode": "apply" if args.apply else "dry-run",
        "server": {"host": args.imap_host, "port": args.imap_port},
        "user": args.user,
        "inbox": args.inbox,
        "scanned": 0,
        "matched": 0,
        "moved": 0,
        "failed": 0,
        "by_target": {},
        "samples": [],
        "errors": [],
    }

    rules = _default_rules()
    conn: imaplib.IMAP4_SSL | None = None

    try:
        conn = imaplib.IMAP4_SSL(args.imap_host, args.imap_port, timeout=30)
        conn.login(args.user, password)

        # Enable UTF-8 mailbox names for Korean folders when supported.
        try:
            conn.enable("UTF8=ACCEPT")
        except Exception:
            pass

        source_mailbox_encoded = _imap_utf7_encode(args.inbox)
        typ, _ = conn.select(source_mailbox_encoded, readonly=not args.apply)
        if typ != "OK":
            raise RuntimeError(f"failed to select inbox: {args.inbox}")

        typ, data = conn.uid("SEARCH", None, "ALL")
        if typ != "OK":
            raise RuntimeError("failed to search inbox")

        raw_uids = data[0] if data and isinstance(data[0], bytes) else b""
        uids = raw_uids.decode("utf-8", errors="replace").split()
        if args.limit > 0:
            uids = uids[-args.limit :]

        report["scanned"] = len(uids)

        targets = {rule.target_mailbox for rule in rules}
        # Some servers reject LIST references aggressively. Validate by COPY step instead.
        available_targets = targets

        pending_delete = False
        for uid in uids:
            ctx = _fetch_context(conn, uid)
            rule = _match_rule(ctx, rules)
            if rule is None:
                continue
            if rule.target_mailbox not in available_targets:
                report["failed"] = int(report["failed"]) + 1
                report["errors"].append(
                    {
                        "uid": uid,
                        "reason": "target_mailbox_not_found",
                        "target": rule.target_mailbox,
                    }
                )
                continue

            report["matched"] = int(report["matched"]) + 1
            by_target = report["by_target"]
            by_target[rule.target_mailbox] = int(by_target.get(rule.target_mailbox, 0)) + 1

            samples = report["samples"]
            if len(samples) < 30:
                samples.append(
                    {
                        "uid": uid,
                        "from": ctx.from_addr,
                        "subject": ctx.subject,
                        "rule": rule.name,
                        "target": rule.target_mailbox,
                    }
                )

            if not args.apply:
                continue

            target_encoded = _imap_utf7_encode(rule.target_mailbox)
            typ, _ = conn.uid("COPY", uid, target_encoded)
            if typ != "OK":
                report["failed"] = int(report["failed"]) + 1
                report["errors"].append(
                    {"uid": uid, "reason": "copy_failed", "target": rule.target_mailbox}
                )
                continue

            typ, _ = conn.uid("STORE", uid, "+FLAGS.SILENT", "(\\Deleted)")
            if typ != "OK":
                report["failed"] = int(report["failed"]) + 1
                report["errors"].append({"uid": uid, "reason": "store_deleted_failed"})
                continue

            pending_delete = True
            report["moved"] = int(report["moved"]) + 1

        if args.apply and pending_delete:
            conn.expunge()

        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if int(report["failed"]) == 0 else 1

    except Exception as exc:  # noqa: BLE001
        report["errors"].append({"type": type(exc).__name__, "message": str(exc)})
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 1
    finally:
        if conn is not None:
            try:
                conn.logout()
            except Exception:
                pass


if __name__ == "__main__":
    sys.exit(main())
