# Error Map

Use this map to classify failures quickly and choose the next action.

## Transport Layer

### `Transport closed`

- Meaning: Codex session cannot reach MCP server process.
- Common causes: stale session bridge, killed process, session restart mismatch.
- Action:
  - Restart Codex session.
  - Run `bash scripts/mcp_snapshot.sh`.
  - Retry one simple MCP call (`get_connection_status`).

### `timed out awaiting tools/call`

- Meaning: MCP process started but does not return in time.
- Common causes: server hang, network stall, dead process state.
- Action:
  - Capture snapshot with `scripts/mcp_snapshot.sh`.
  - Restart session and retry.
  - If persistent, test direct IMAP/SMTP with `check_mail_auth.py`.

## Authentication Layer

### `Not authenticated`

- Meaning: account login failed inside MCP.
- Common causes: app password mismatch, expired/revoked app password, trailing character issue.
- Action:
  - Rewrite pass file as exactly one line.
  - Keep permission `600`.
  - Run direct check:
    - `python3 scripts/check_mail_auth.py ...`
  - If direct check fails, issue is credentials/account policy.

## Mailbox Workflow Layer

### `No mailbox is currently selected`

- Meaning: mailbox operation requested before opening/selecting mailbox.
- Action:
  - Call open mailbox step first.
  - Retry message count/search.

## Network / Environment Layer

### `gaierror` or DNS resolution failure

- Meaning: host lookup failed in current runtime environment.
- Common causes: sandbox DNS restriction, temporary network outage.
- Action:
  - Retry from environment with real network access.
  - Verify hostnames and connectivity before blaming credentials.

## Completion Criteria

Treat recovery as complete only when all are true:

1. MCP call succeeds (`get_connection_status` or message query).
2. Direct IMAP login succeeds.
3. Direct SMTP login succeeds.
4. One mailbox read operation succeeds.
