#!/usr/bin/env python3
"""Check direct DNS/IMAP/SMTP auth for a mail account without exposing secrets."""

from __future__ import annotations

import argparse
import imaplib
import json
import smtplib
import socket
import sys
from pathlib import Path
from typing import Any


def _resolve(host: str) -> dict[str, Any]:
    try:
        infos = socket.getaddrinfo(host, None, proto=socket.IPPROTO_TCP)
        addrs = sorted({item[4][0] for item in infos if item and item[4]})
        return {"ok": True, "addresses": addrs}
    except Exception as exc:  # noqa: BLE001
        return {"ok": False, "error_type": type(exc).__name__, "error": str(exc)}


def _imap_check(
    host: str, port: int, user: str, password: str, timeout: int, check_inbox: bool
) -> dict[str, Any]:
    result: dict[str, Any] = {"ok": False}
    conn: imaplib.IMAP4_SSL | None = None
    try:
        conn = imaplib.IMAP4_SSL(host, port, timeout=timeout)
        typ, data = conn.login(user, password)
        result["login"] = {"typ": typ, "data": _decode_first(data)}
        if check_inbox:
            typ, _ = conn.select("INBOX", readonly=True)
            result["select"] = {"typ": typ}

            typ, data = conn.search(None, "ALL")
            result["count_all"] = _count_search_result(data)

            typ, data = conn.search(None, "UNSEEN")
            result["count_unseen"] = _count_search_result(data)

        result["ok"] = True
        return result
    except Exception as exc:  # noqa: BLE001
        result.update({"error_type": type(exc).__name__, "error": str(exc)})
        return result
    finally:
        if conn is not None:
            try:
                conn.logout()
            except Exception:  # noqa: BLE001
                pass


def _smtp_check(host: str, port: int, user: str, password: str, timeout: int) -> dict[str, Any]:
    result: dict[str, Any] = {"ok": False}
    conn: smtplib.SMTP_SSL | None = None
    try:
        conn = smtplib.SMTP_SSL(host, port, timeout=timeout)
        code, message = conn.login(user, password)
        result.update(
            {
                "ok": True,
                "login": {"code": code, "message": _decode_bytes(message)},
            }
        )
        return result
    except Exception as exc:  # noqa: BLE001
        result.update({"error_type": type(exc).__name__, "error": str(exc)})
        return result
    finally:
        if conn is not None:
            try:
                conn.quit()
            except Exception:  # noqa: BLE001
                pass


def _decode_first(data: Any) -> str:
    if not data:
        return ""
    first = data[0]
    return _decode_bytes(first)


def _decode_bytes(value: Any) -> str:
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return str(value)


def _count_search_result(data: Any) -> int:
    if not data:
        return 0
    first = data[0] if isinstance(data, (list, tuple)) else data
    if isinstance(first, bytes):
        return len(first.split())
    return len(str(first).split())


def _load_password(path: Path) -> str:
    raw = path.read_text(encoding="utf-8")
    password = raw.strip("\r\n")
    if not password:
        raise ValueError("password is empty after trimming newline")
    return password


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--user", required=True, help="Email account user")
    parser.add_argument("--imap-host", required=True, help="IMAP host")
    parser.add_argument("--imap-port", type=int, default=993, help="IMAP port (default: 993)")
    parser.add_argument("--smtp-host", required=True, help="SMTP host")
    parser.add_argument("--smtp-port", type=int, default=465, help="SMTP port (default: 465)")
    parser.add_argument("--pass-file", required=True, help="Password file path (single line)")
    parser.add_argument("--timeout", type=int, default=20, help="Socket timeout seconds")
    parser.add_argument(
        "--check-inbox",
        action="store_true",
        help="Also select INBOX and count ALL/UNSEEN via IMAP",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    pass_path = Path(args.pass_file).expanduser()

    result: dict[str, Any] = {
        "user": args.user,
        "imap": {"host": args.imap_host, "port": args.imap_port},
        "smtp": {"host": args.smtp_host, "port": args.smtp_port},
        "pass_file": str(pass_path),
        "checks": {},
    }

    if not pass_path.exists():
        result["checks"]["password_file"] = {"ok": False, "error": "file not found"}
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 2

    try:
        password = _load_password(pass_path)
    except Exception as exc:  # noqa: BLE001
        result["checks"]["password_file"] = {
            "ok": False,
            "error_type": type(exc).__name__,
            "error": str(exc),
        }
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 2

    result["checks"]["password_file"] = {"ok": True}
    result["checks"]["dns_imap"] = _resolve(args.imap_host)
    result["checks"]["dns_smtp"] = _resolve(args.smtp_host)
    result["checks"]["imap"] = _imap_check(
        args.imap_host,
        args.imap_port,
        args.user,
        password,
        args.timeout,
        args.check_inbox,
    )
    result["checks"]["smtp"] = _smtp_check(
        args.smtp_host,
        args.smtp_port,
        args.user,
        password,
        args.timeout,
    )

    all_ok = (
        result["checks"]["password_file"]["ok"]
        and result["checks"]["dns_imap"]["ok"]
        and result["checks"]["dns_smtp"]["ok"]
        and result["checks"]["imap"]["ok"]
        and result["checks"]["smtp"]["ok"]
    )
    result["ok"] = all_ok

    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0 if all_ok else 1


if __name__ == "__main__":
    sys.exit(main())
