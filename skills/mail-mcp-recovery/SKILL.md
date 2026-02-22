---
name: mail-mcp-recovery
description: Diagnose and recover Codex mail MCP failures for NATE/NAVER mail accounts. Use when mail MCP calls fail with Transport closed, Not authenticated, timeouts, mailbox selection errors, or when you must verify whether message read/send failures come from MCP transport versus account credentials.
---

# Mail MCP Recovery

## Overview

Recover mail MCP reliability with a deterministic flow: inspect MCP registration/runtime state, isolate transport issues from credential issues, and verify inbox operations before reporting completion.

## Quick Start

1. Capture MCP registration and process state.
```bash
bash scripts/mcp_snapshot.sh
```
2. If MCP tools return `Transport closed`, restart the Codex session before deeper debugging.
3. Validate account credentials directly against IMAP/SMTP.
```bash
python3 scripts/check_mail_auth.py \
  --user simsun@nate.com \
  --imap-host imap.nate.com \
  --smtp-host smtp.mail.nate.com \
  --pass-file /home/qwe/.config/codex-secrets/simsun_nate.pass \
  --check-inbox
```
4. Repeat direct check for NAVER.
```bash
python3 scripts/check_mail_auth.py \
  --user simsunsim@naver.com \
  --imap-host imap.naver.com \
  --smtp-host smtp.naver.com \
  --pass-file /home/qwe/.config/codex-secrets/simsunsim_naver.pass \
  --check-inbox
```

## Workflow

### 1) Check MCP registration and runtime

- Run `bash scripts/mcp_snapshot.sh`.
- Confirm servers are present and `enabled` in `codex mcp list`.
- Confirm runtime calls are possible. If every call fails with `Transport closed`, treat this as bridge/session failure, not account failure.

### 2) Classify the failure

- Use `references/error-map.md` to map the first observed error to likely root causes.
- Distinguish between:
  - Transport-layer failures (`Transport closed`, global tool timeout)
  - Auth failures (`Not authenticated`, login rejected)
  - Workflow failures (`No mailbox is currently selected`)

### 3) Validate credentials outside MCP

- Run `scripts/check_mail_auth.py` with account-specific host/user/pass file.
- Confirm:
  - DNS resolution
  - IMAP login
  - SMTP login
  - Optional inbox select/count (`--check-inbox`)
- If direct checks pass but MCP fails, focus on MCP process/session recovery.

### 4) Apply recovery action

- For transport failure:
  - Restart Codex session and rerun `mcp_snapshot.sh`.
- For auth failure:
  - Rewrite pass file with single-line app password.
  - Keep permission at `600`.
  - Retry direct auth check.
- For mailbox selection failure:
  - Open mailbox before read/search operations.

### 5) Verify end-to-end

- Run one read path (`get_recent_messages` or subject search).
- Run one send path if required by task.
- Report with concrete timestamps and pass/fail by layer: `MCP transport`, `IMAP`, `SMTP`, `mailbox operations`.

## Scripts

- `scripts/mcp_snapshot.sh`: Print `codex mcp list/get` and mail-MCP process snapshot.
- `scripts/check_mail_auth.py`: Perform direct DNS/IMAP/SMTP checks without exposing secrets.

## References

- `references/error-map.md`: Error-to-action map for rapid triage.
