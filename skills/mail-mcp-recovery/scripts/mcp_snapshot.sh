#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -eq 0 ]; then
  servers=(nate_mail naver_mail)
else
  servers=("$@")
fi

if ! command -v codex >/dev/null 2>&1; then
  echo "codex CLI not found in PATH" >&2
  exit 1
fi

echo "== codex mcp list =="
codex mcp list || true
echo

for server in "${servers[@]}"; do
  echo "== codex mcp get ${server} =="
  codex mcp get "${server}" || true
  echo
done

echo "== process snapshot (mail MCP) =="
ps -eo pid,ppid,etime,cmd | rg 'mcp-mail-server|run-spsmail-mcp.sh|codex mcp' | rg -v rg || true
