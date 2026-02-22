#!/usr/bin/env bash
set -euo pipefail

SECRETS_DIR="${NAVER_SECRETS_DIR:-$HOME/.config/codex-secrets}"
CLIENT_ID_FILE="${NAVER_CLIENT_ID_FILE:-$SECRETS_DIR/naver_client_id.pass}"
CLIENT_SECRET_FILE="${NAVER_CLIENT_SECRET_FILE:-$SECRETS_DIR/naver_client_secret.pass}"
REFRESH_TOKEN_FILE="${NAVER_REFRESH_TOKEN_FILE:-$SECRETS_DIR/naver_refresh_token.pass}"
ACCESS_TOKEN_FILE="${NAVER_ACCESS_TOKEN_FILE:-$SECRETS_DIR/naver_access_token.pass}"
TOKEN_ENDPOINT="${NAVER_TOKEN_ENDPOINT:-https://nid.naver.com/oauth2.0/token}"

read_secret() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing secret file: $path" >&2
    return 1
  fi
  local value
  value="$(tr -d '\r\n' < "$path")"
  if [[ -z "$value" ]]; then
    echo "Empty secret file: $path" >&2
    return 1
  fi
  printf '%s' "$value"
}

CLIENT_ID="$(read_secret "$CLIENT_ID_FILE")"
CLIENT_SECRET="$(read_secret "$CLIENT_SECRET_FILE")"
REFRESH_TOKEN="$(read_secret "$REFRESH_TOKEN_FILE")"

RESPONSE="$(
  curl -sG "$TOKEN_ENDPOINT" \
    --data-urlencode "grant_type=refresh_token" \
    --data-urlencode "client_id=$CLIENT_ID" \
    --data-urlencode "client_secret=$CLIENT_SECRET" \
    --data-urlencode "refresh_token=$REFRESH_TOKEN"
)"

parse_field() {
  local field="$1"
  python3 - "$field" "$RESPONSE" <<'PY'
import json
import sys
key = sys.argv[1]
raw = sys.argv[2]
try:
    data = json.loads(raw)
except Exception:
    print("")
    raise SystemExit(0)
value = data.get(key, "")
if isinstance(value, str):
    print(value)
else:
    print(str(value))
PY
}

ACCESS_TOKEN="$(parse_field access_token)"
EXPIRES_IN="$(parse_field expires_in)"
ERROR_CODE="$(parse_field error)"
ERROR_DESC="$(parse_field error_description)"

if [[ -z "$ACCESS_TOKEN" ]]; then
  echo "Failed to refresh token." >&2
  echo "error=$ERROR_CODE" >&2
  echo "error_description=$ERROR_DESC" >&2
  echo "response=$RESPONSE" >&2
  exit 1
fi

install -m 600 /dev/null "$ACCESS_TOKEN_FILE"
printf '%s\n' "$ACCESS_TOKEN" > "$ACCESS_TOKEN_FILE"

echo "Naver access token refreshed."
echo "access_token_file=$ACCESS_TOKEN_FILE"
echo "expires_in=${EXPIRES_IN:-unknown}"
