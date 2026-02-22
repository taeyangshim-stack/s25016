#!/usr/bin/env bash
set -euo pipefail

SECRETS_DIR="${NAVER_SECRETS_DIR:-$HOME/.config/codex-secrets}"
mkdir -p "$SECRETS_DIR"
chmod 700 "$SECRETS_DIR"

write_secret() {
  local prompt="$1"
  local file="$2"
  local secret="${3:-yes}"
  local value=""

  while [[ -z "$value" ]]; do
    if [[ "$secret" == "yes" ]]; then
      read -r -s -p "$prompt" value
      echo
    else
      read -r -p "$prompt" value
    fi
    value="$(printf '%s' "$value" | tr -d '\r\n')"
    if [[ -z "$value" ]]; then
      echo "Empty value is not allowed. Please try again."
    fi
  done

  install -m 600 /dev/null "$file"
  printf '%s\n' "$value" > "$file"
}

echo "Setting up one-time Naver Calendar secrets in: $SECRETS_DIR"
echo

write_secret "NAVER_CLIENT_ID: " "$SECRETS_DIR/naver_client_id.pass" "no"
write_secret "NAVER_CLIENT_SECRET: " "$SECRETS_DIR/naver_client_secret.pass" "yes"
write_secret "NAVER_REFRESH_TOKEN: " "$SECRETS_DIR/naver_refresh_token.pass" "yes"
read -r -p "NAVER_CALENDAR_ORGANIZER [simsunsim@naver.com]: " ORGANIZER
ORGANIZER="$(printf '%s' "$ORGANIZER" | tr -d '\r\n')"
if [[ -z "$ORGANIZER" ]]; then
  ORGANIZER="simsunsim@naver.com"
fi
install -m 600 /dev/null "$SECRETS_DIR/naver_calendar_organizer.pass"
printf '%s\n' "$ORGANIZER" > "$SECRETS_DIR/naver_calendar_organizer.pass"

echo
echo "Saved files:"
echo "  $SECRETS_DIR/naver_client_id.pass"
echo "  $SECRETS_DIR/naver_client_secret.pass"
echo "  $SECRETS_DIR/naver_refresh_token.pass"
echo "  $SECRETS_DIR/naver_calendar_organizer.pass"
echo
echo "Next:"
echo "  bash /home/qwe/works/s25016/scripts/naver_refresh_access_token.sh"
echo "  bash /home/qwe/works/s25016/scripts/naver_calendar_create.sh --help"
