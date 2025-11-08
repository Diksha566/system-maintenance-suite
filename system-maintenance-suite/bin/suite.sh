#!/usr/bin/env bash
set -Euo pipefail
IFS=$'\n\t'
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC1091
source "$DIR/../lib/common.sh"

menu() {
  msg_step "====== Maintenance ======"
  echo "1) ${COLOR_CYAN}Backup now${COLOR_RESET}"
  echo "2) ${COLOR_CYAN}Update + clean${COLOR_RESET}"
  echo "3) ${COLOR_CYAN}Scan logs (1h)${COLOR_RESET}"
  echo "4) ${COLOR_CYAN}Scan logs (today)${COLOR_RESET}"
  echo "5) ${COLOR_CYAN}Run all (2->1->3)${COLOR_RESET}"
  echo "q) ${COLOR_YELLOW}Quit${COLOR_RESET}"
  msg_step "========================="
}

while true; do
  menu
  read -rp "Choose: " ch
  case "$ch" in
    1) "$DIR/backup.sh" ;;
    2) "$DIR/update_clean.sh" ;;
    3) LOG_SINCE="1h"  "$DIR/log_watch.sh" ;;
    4) LOG_SINCE="today" "$DIR/log_watch.sh" ;;
    5) "$DIR/update_clean.sh" && "$DIR/backup.sh" && LOG_SINCE="1h" "$DIR/log_watch.sh" ;;
    q|Q) exit 0 ;;
    *) echo "unknown choice" ;;
  esac
done
