#!/usr/bin/env bash
# Compact log scan with journalctl filters.

set -Euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../lib/common.sh"
# load_env "$SCRIPT_DIR/../etc/.env.local"
load_env

since="${1:-${LOG_SINCE:-1h}}"
prio="${2:-${LOG_PRIORITY:-warning}}"

need_cmd journalctl
msg_step "Scanning logs: since=$since prio>=$prio"

mapfile -t hits < <(journalctl -p "$prio" --since "$since" -o short-iso --no-pager 2>/dev/null \
  | grep -E 'error|failed|critical|panic|oom' || true)

if ((${#hits[@]}==0)); then
  msg_ok "No high-priority issues detected"
  log "log scan ok (since=$since prio>=$prio)"
  exit 0
fi

msg_warn "Found ${#hits[@]} relevant log entries"
printf '%s\n' "${hits[@]}"
log "log scan found ${#hits[@]} issues"
exit 1
