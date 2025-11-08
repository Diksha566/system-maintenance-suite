#!/usr/bin/env bash
# Common helpers for maintenance suite.

set -Euo pipefail
IFS=$'\n\t'

# ----- color init (tput first, ANSI fallback) -----
COLOR_RESET=""
COLOR_BOLD=""
COLOR_RED=""; COLOR_GREEN=""; COLOR_YELLOW=""; COLOR_BLUE=""; COLOR_MAGENTA=""; COLOR_CYAN=""

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
  if [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
    COLOR_RESET="$(tput sgr0)"
    COLOR_BOLD="$(tput bold)"
    COLOR_RED="$(tput setaf 1)"
    COLOR_GREEN="$(tput setaf 2)"
    COLOR_YELLOW="$(tput setaf 3)"
    COLOR_BLUE="$(tput setaf 4)"
    COLOR_MAGENTA="$(tput setaf 5)"
    COLOR_CYAN="$(tput setaf 6)"
  fi
fi
if [[ -z "${COLOR_RESET}" ]]; then
  COLOR_RESET=$'\033[0m'
  COLOR_BOLD=$'\033[1m'
  COLOR_RED=$'\033[31m'
  COLOR_GREEN=$'\033[32m'
  COLOR_YELLOW=$'\033[33m'
  COLOR_BLUE=$'\033[34m'
  COLOR_MAGENTA=$'\033[35m'
  COLOR_CYAN=$'\033[36m'
fi

cecho() { local c="${1:-$COLOR_RESET}"; shift || true; printf '%s%s%s\n' "$c" "$*" "$COLOR_RESET"; }
msg_step() { cecho "$COLOR_BLUE$COLOR_BOLD" "$@"; }
msg_ok()   { cecho "$COLOR_GREEN" "$@"; }
msg_warn() { cecho "$COLOR_YELLOW" "$@"; }
msg_err()  { cecho "$COLOR_RED" "$@"; }

# ----- logging & utils -----
log() { printf '%s %s\n' "[$(date +'%F %T')]" "$*"; logger -t maint "$*"; }
die() { msg_err "ERROR: $*"; log "ERROR: $*"; exit 1; }
need_cmd() { command -v "$1" >/dev/null 2>&1 || die "missing command: $1"; }

# Load variables from an env file if present (default system location).
load_env() {
  local env_file="${1:-/etc/maintenance-suite/env}"
  [[ -f "$env_file" ]] && # shellcheck disable=SC1090
    source "$env_file"
}

# Echo the command (cyan) and run it unless DRY_RUN=1.
run() {
  cecho "$COLOR_CYAN" "$*"
  if [[ "${DRY_RUN:-0}" = "1" ]]; then
    return 0
  fi
  "$@"
}

# Trap prints failing command/line and exits with original code.
trap 'rc=$?; log "failed at line $LINENO: $BASH_COMMAND (exit $rc)"; exit $rc' ERR
