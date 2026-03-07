#!/usr/bin/env python3
"""Weekly Kakao mail classification audit/report with optional apply mode."""

from __future__ import annotations

import argparse
import base64
import imaplib
import json
from dataclasses import asdict, dataclass
from datetime import datetime, timedelta
from email import message_from_bytes
from email.header import decode_header
from pathlib import Path


SOURCE_SP_RECEIVED = "SP받은편지함"
SOURCE_SOCIAL = "소셜"

RULES: list[tuple[str, list[str]]] = [
    ("청구서", ["청구", "명세서", "invoice", "bill", "payment", "이용대금", "카드", "급여명세서", "세금계산서"]),
    (
        "SP프로젝트",
        ["s25016", "planb", "라이트커튼", "갠트리", "용접", "설치계획서", "b라인", "소조립", "삼성중공업"],
    ),
    ("과제관련", ["과제", "정부과제", "컨소시엄", "평가", "장비 설치", "회의록", "r&d"]),
    ("SP공유", ["공유", "자료", "피드백", "토론회", "r&r", "리마인드"]),
]

SOCIAL_SENDERS = ["facebook", "linkedin", "x.com", "twitter", "instagram", "discord", "kakao", "notion"]


@dataclass
class Candidate:
    source: str
    uid: str
    date: str
    from_text: str
    subject: str
    suggested_dest: str
    reason: str


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--imap-host", default="imap.kakao.com")
    parser.add_argument("--imap-port", type=int, default=993)
    parser.add_argument("--user", default="simsun@kakao.com")
    parser.add_argument(
        "--pass-file",
        default="/home/qwe/.config/codex-secrets/simsun_kakao.pass",
        help="Path to password file (single line).",
    )
    parser.add_argument("--since-days", type=int, default=7, help="SP받은편지함 검색 기간(일).")
    parser.add_argument(
        "--social-all",
        action="store_true",
        help="소셜 폴더는 기간 제한 없이 전체 스캔합니다.",
    )
    parser.add_argument(
        "--apply",
        action="store_true",
        help="실제 이동 적용. 미지정 시 드라이런(리포트만).",
    )
    parser.add_argument(
        "--report-dir",
        default="250917_상하축이슈/05_문서자료/mail_audit_reports",
        help="리포트 저장 디렉터리. 미지정 시 기본 경로 사용.",
    )
    parser.add_argument(
        "--no-write-report",
        action="store_true",
        help="파일 저장 없이 콘솔 JSON만 출력.",
    )
    return parser.parse_args()


def decode_mime(value: str | None) -> str:
    if not value:
        return ""
    decoded: list[str] = []
    for chunk, charset in decode_header(value):
        if isinstance(chunk, bytes):
            encoding = charset or "utf-8"
            try:
                decoded.append(chunk.decode(encoding, errors="replace"))
            except Exception:
                decoded.append(chunk.decode("utf-8", errors="replace"))
        else:
            decoded.append(chunk)
    return "".join(decoded).strip()


def imap_utf7_encode(mailbox: str) -> str:
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
        if 0x20 <= ord(ch) <= 0x7E:
            flush_buff()
            out.append("&-" if ch == "&" else ch)
        else:
            buff.append(ch)
    flush_buff()
    return "".join(out)


def classify(source: str, from_text: str, subject: str) -> tuple[str | None, str]:
    blob = f"{from_text} {subject}".lower()
    if source == SOURCE_SP_RECEIVED:
        for dest, keywords in RULES:
            if any(keyword.lower() in blob for keyword in keywords):
                return dest, f"키워드 매칭({dest})"
        return None, "분기 규칙 미해당"

    if source == SOURCE_SOCIAL:
        if any(sender in blob for sender in SOCIAL_SENDERS):
            return None, "소셜 알림 패턴"
        for dest, keywords in RULES:
            if any(keyword.lower() in blob for keyword in keywords):
                return dest, f"키워드 매칭({dest})"
        return SOURCE_SP_RECEIVED, "소셜 내 업무성 메일 기본 분류"

    return None, "대상외"


def move_uid(conn: imaplib.IMAP4_SSL, uid: str, dest: str) -> tuple[bool, str]:
    dest_encoded = imap_utf7_encode(dest)
    typ, _ = conn.uid("COPY", uid, dest_encoded)
    if typ != "OK":
        return False, "copy_failed"
    typ, _ = conn.uid("STORE", uid, "+FLAGS.SILENT", "(\\Deleted)")
    if typ != "OK":
        return False, "store_deleted_failed"
    return True, "moved"


def fetch_candidates(
    conn: imaplib.IMAP4_SSL,
    source: str,
    search_criteria: tuple[str, ...],
) -> tuple[int, list[Candidate]]:
    source_encoded = imap_utf7_encode(source)
    if conn.select(source_encoded, readonly=False)[0] != "OK":
        return 0, []

    typ, data = conn.uid("SEARCH", None, *search_criteria)
    if typ != "OK" or not data or not data[0]:
        return 0, []

    uids = data[0].decode("utf-8", errors="replace").split()
    candidates: list[Candidate] = []

    for uid in uids:
        typ, fetched = conn.uid(
            "FETCH",
            uid,
            "(BODY.PEEK[HEADER.FIELDS (FROM SUBJECT DATE)])",
        )
        if typ != "OK" or not fetched:
            continue

        header_bytes = b""
        for chunk in fetched:
            if isinstance(chunk, tuple):
                header_bytes = chunk[1]
                break
        if not header_bytes:
            continue

        message = message_from_bytes(header_bytes)
        from_text = decode_mime(message.get("From", ""))
        subject = decode_mime(message.get("Subject", ""))
        date = decode_mime(message.get("Date", ""))
        suggested_dest, reason = classify(source, from_text, subject)
        if not suggested_dest:
            continue

        candidates.append(
            Candidate(
                source=source,
                uid=uid,
                date=date,
                from_text=from_text,
                subject=subject,
                suggested_dest=suggested_dest,
                reason=reason,
            )
        )

    return len(uids), candidates


def write_markdown_report(path: Path, report: dict[str, object]) -> None:
    lines: list[str] = []
    lines.append(f"# Kakao Mail Weekly Audit ({report['timestamp']})")
    lines.append("")
    lines.append(f"- Mode: `{report['mode']}`")
    lines.append(f"- Account: `{report['user']}`")
    lines.append(f"- SP받은편지함 scanned: `{report['scanned']['SP받은편지함']}`")
    lines.append(f"- 소셜 scanned: `{report['scanned']['소셜']}`")
    lines.append(f"- Candidates: `{report['candidate_count']}`")
    lines.append(f"- Moved: `{report['moved']}`")
    lines.append(f"- Failed: `{report['failed']}`")
    lines.append("")
    lines.append("## Candidates")
    lines.append("")

    candidates: list[dict[str, str]] = report["candidates"]  # type: ignore[assignment]
    if not candidates:
        lines.append("- No candidates.")
    else:
        for item in candidates:
            lines.append(
                "- "
                f"[{item['source']}] UID {item['uid']} -> {item['suggested_dest']} | "
                f"{item['subject']} | {item['reason']}"
            )

    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    args = parse_args()
    password = Path(args.pass_file).expanduser().read_text(encoding="utf-8").strip()
    since_value = (datetime.now() - timedelta(days=args.since_days)).strftime("%d-%b-%Y")

    report: dict[str, object] = {
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "mode": "apply" if args.apply else "dry-run",
        "user": args.user,
        "server": {"host": args.imap_host, "port": args.imap_port},
        "since_days": args.since_days,
        "scanned": {SOURCE_SP_RECEIVED: 0, SOURCE_SOCIAL: 0},
        "candidate_count": 0,
        "moved": 0,
        "failed": 0,
        "candidates": [],
        "errors": [],
    }

    conn: imaplib.IMAP4_SSL | None = None
    try:
        conn = imaplib.IMAP4_SSL(args.imap_host, args.imap_port, timeout=30)
        conn.login(args.user, password)

        sp_scanned, sp_candidates = fetch_candidates(
            conn,
            SOURCE_SP_RECEIVED,
            ("SINCE", since_value),
        )
        social_criteria = ("ALL",) if args.social_all else ("SINCE", since_value)
        social_scanned, social_candidates = fetch_candidates(conn, SOURCE_SOCIAL, social_criteria)

        all_candidates = sp_candidates + social_candidates
        report["scanned"] = {SOURCE_SP_RECEIVED: sp_scanned, SOURCE_SOCIAL: social_scanned}
        report["candidate_count"] = len(all_candidates)
        report["candidates"] = [asdict(candidate) for candidate in all_candidates]

        if args.apply:
            grouped: dict[str, list[Candidate]] = {}
            for candidate in all_candidates:
                grouped.setdefault(candidate.source, []).append(candidate)

            for source, items in grouped.items():
                source_encoded = imap_utf7_encode(source)
                if conn.select(source_encoded, readonly=False)[0] != "OK":
                    report["failed"] = int(report["failed"]) + len(items)
                    report["errors"].append(f"source_select_failed: {source}")
                    continue

                pending_delete = False
                for item in items:
                    ok, status = move_uid(conn, item.uid, item.suggested_dest)
                    if ok:
                        report["moved"] = int(report["moved"]) + 1
                        pending_delete = True
                    else:
                        report["failed"] = int(report["failed"]) + 1
                        report["errors"].append(f"uid={item.uid} source={source} status={status}")

                if pending_delete:
                    conn.expunge()

        if not args.no_write_report:
            report_dir = Path(args.report_dir)
            report_dir.mkdir(parents=True, exist_ok=True)
            stamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            json_path = report_dir / f"{stamp}_kakao_mail_weekly_audit.json"
            md_path = report_dir / f"{stamp}_kakao_mail_weekly_audit.md"
            json_path.write_text(json.dumps(report, ensure_ascii=False, indent=2), encoding="utf-8")
            write_markdown_report(md_path, report)
            report["report_files"] = {"json": str(json_path), "markdown": str(md_path)}

        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 0 if int(report["failed"]) == 0 else 1
    except Exception as exc:  # noqa: BLE001
        report["errors"].append(f"{type(exc).__name__}: {exc}")
        print(json.dumps(report, ensure_ascii=False, indent=2))
        return 1
    finally:
        if conn is not None:
            try:
                conn.logout()
            except Exception:
                pass


if __name__ == "__main__":
    raise SystemExit(main())
