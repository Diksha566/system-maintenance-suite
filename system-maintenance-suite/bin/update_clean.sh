#!/usr/bin/env bash
# System update + cleanup with manager detection.

set -Euo pipefail
IFS=$'\n\t'
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/../lib/common.sh"
# load_env "$SCRIPT_DIR/../etc/.env.local"
load_env

pm="${PM_OVERRIDE:-}"
if [[ -z "$pm" ]]; then
  for c in apt-get dnf pacman zypper; do
    command -v "$c" >/dev/null 2>&1 && { pm="$c"; break; }
  done
fi
[[ -n "$pm" ]] || die "no supported package manager found"

msg_step "Running updates with: $pm"
case "$pm" in
  apt-get)
    need_cmd apt-get
    run sudo apt-get update
    run sudo apt-get -y upgrade
    run sudo apt-get -y autoremove
    run sudo apt-get -y autoclean
    ;;
  dnf)
    need_cmd dnf
    run sudo dnf -y upgrade
    run sudo dnf -y autoremove || true
    run sudo dnf clean all -y
    ;;
  pacman)
    need_cmd pacman
    run sudo pacman -Syu --noconfirm
    run sudo pacman -Scc --noconfirm
    ;;
  zypper)
    need_cmd zypper
    run sudo zypper -n refresh
    run sudo zypper -n update
    run sudo zypper -n clean --all
    ;;
  *) die "unsupported: $pm" ;;
esac

msg_ok "Update + cleanup completed"
log "update+clean done ($pm)"
