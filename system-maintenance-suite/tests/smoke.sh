#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "[smoke] common.sh loads"
bash -c "source '$DIR/lib/common.sh'; msg_ok ok" >/dev/null

echo "[smoke] dry-run backup"
DRY_RUN=1 BACKUP_SOURCES=("$HOME") BACKUP_DEST="$DIR/var/backups" "$DIR/bin/backup.sh" || true

echo "[smoke] log scan (should succeed even if empty)"
"$DIR/bin/log_watch.sh" "5m" "warning" || true

echo "[smoke] update detection only"
bash -c "source '$DIR/lib/common.sh'; for c in apt-get dnf pacman zypper; do command -v \$c && echo found \$c && exit 0; done; echo none; exit 0"
