#!/usr/bin/env bash
# Incremental snapshot backup with retention.

set -Euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../lib/common.sh"
# Try system env; if developing locally, uncomment to load project env:
# load_env "$SCRIPT_DIR/../etc/.env.local"
load_env

: "${BACKUP_SOURCES:?set BACKUP_SOURCES (bash array) in /etc/maintenance-suite/env}"
: "${BACKUP_DEST:?set BACKUP_DEST in /etc/maintenance-suite/env}"
: "${BACKUP_RETENTION:=7}"

need_cmd rsync
run mkdir -p "$BACKUP_DEST"

stamp="$(date +'%Y-%m-%d_%H-%M-%S')"
target="$BACKUP_DEST/$stamp"
last_link="$BACKUP_DEST/latest"
msg_step "Starting backup to $target"
run mkdir -p "$target"

link_opt=()
[[ -e "$last_link" ]] && link_opt=(--link-dest="$last_link")

for src in "${BACKUP_SOURCES[@]}"; do
  [[ -e "$src" ]] || { msg_warn "skip missing: $src"; continue; }
  run rsync -aHAX --delete --numeric-ids "${link_opt[@]}" -- "$src" "$target/"
done

tmp="$BACKUP_DEST/.latest.tmp"
run ln -sfn "$target" "$tmp"
run mv -Tf "$tmp" "$last_link"

mapfile -t snaps < <(ls -1dt "$BACKUP_DEST"/*/ 2>/dev/null || true)
if (( ${#snaps[@]} > BACKUP_RETENTION )); then
  for old in "${snaps[@]:BACKUP_RETENTION}"; do
    [[ "$(basename "$old")" == "latest" ]] && continue
    msg_warn "purge $old"
    run rm -rf -- "$old"
  done
fi

msg_ok "Backup completed -> $target"
log "backup ok -> $target"
