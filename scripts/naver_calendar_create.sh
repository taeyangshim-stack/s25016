#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="/home/qwe/works/s25016"
SECRETS_DIR="${NAVER_SECRETS_DIR:-$HOME/.config/codex-secrets}"
ACCESS_TOKEN_FILE="${NAVER_ACCESS_TOKEN_FILE:-$SECRETS_DIR/naver_access_token.pass}"
ORGANIZER_FILE="${NAVER_ORGANIZER_FILE:-$SECRETS_DIR/naver_calendar_organizer.pass}"
REFRESH_SCRIPT="${NAVER_REFRESH_SCRIPT:-$ROOT_DIR/scripts/naver_refresh_access_token.sh}"
CREATE_SCRIPT="${NAVER_CREATE_SCRIPT:-$HOME/.codex/skills/naver-calendar-ops/scripts/create_schedule.py}"

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  cat <<'EOF'
Usage:
  naver_calendar_create.sh [create_schedule.py create args...]

Examples:
  naver_calendar_create.sh \
    --title '[S25016] 메일 발송 기록' \
    --start '2026-02-23 02:46' \
    --end '2026-02-23 03:00' \
    --location '온라인' \
    --description 'G팀 회신 발송'

Notes:
  - This script refreshes Naver access token before each create call.
  - One-time setup files are required in ~/.config/codex-secrets:
    naver_client_id.pass
    naver_client_secret.pass
    naver_refresh_token.pass
    naver_calendar_organizer.pass (optional, default: simsunsim@naver.com)
EOF
  exit 0
fi

if [[ ! -x "$REFRESH_SCRIPT" ]]; then
  echo "Missing refresh script: $REFRESH_SCRIPT" >&2
  exit 1
fi
if [[ ! -f "$CREATE_SCRIPT" ]]; then
  echo "Missing Naver calendar create script: $CREATE_SCRIPT" >&2
  exit 1
fi

# Always refresh before create to avoid expiry issues.
"$REFRESH_SCRIPT"

if [[ ! -f "$ACCESS_TOKEN_FILE" ]]; then
  echo "Missing access token file: $ACCESS_TOKEN_FILE" >&2
  exit 1
fi

NAVER_ACCESS_TOKEN="$(tr -d '\r\n' < "$ACCESS_TOKEN_FILE")"
if [[ -z "$NAVER_ACCESS_TOKEN" ]]; then
  echo "Access token file is empty: $ACCESS_TOKEN_FILE" >&2
  exit 1
fi

if [[ -f "$ORGANIZER_FILE" ]]; then
  NAVER_CALENDAR_ORGANIZER="$(tr -d '\r\n' < "$ORGANIZER_FILE")"
else
  NAVER_CALENDAR_ORGANIZER="${NAVER_CALENDAR_ORGANIZER:-simsunsim@naver.com}"
fi
if [[ -z "$NAVER_CALENDAR_ORGANIZER" ]]; then
  echo "Organizer is empty. Set NAVER_CALENDAR_ORGANIZER or create $ORGANIZER_FILE" >&2
  exit 1
fi

export NAVER_ACCESS_TOKEN
export NAVER_CALENDAR_ORGANIZER

python3 "$CREATE_SCRIPT" create "$@"
