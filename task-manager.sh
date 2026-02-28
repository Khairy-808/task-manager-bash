#!/bin/bash
# ==============================
# Mini Task Manager (Simple + Colors + Title Validation)
# Tools: awk, sed, grep, date, read
# Storage format: ID|Title|Priority|DueDate|Status
# ==============================

TASK_FILE="tasks.txt"

# ---------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# --------- init file ---------
[ -f "$TASK_FILE" ] || touch "$TASK_FILE"

pause() { echo; read -r -p "Press Enter to continue..." _; }

# ------------------------------
# Title validation:
# - Not empty
# - Only letters/numbers/spaces allowed (no symbols like ? ! @ etc.)
valid_title() {
  [[ "$1" =~ ^[A-Za-z0-9[:space:]]+$ ]]
}

# ------------------------------
# Generate ID (MAX ID + 1) using awk
generate_id() {
  awk -F'|' '
    BEGIN { max=0 }
    $1 ~ /^[0-9]+$/ { if ($1 > max) max=$1 }
    END { print max+1 }
  ' "$TASK_FILE"
}

# ------------------------------
# Validate date (prints formatted date only)
validate_date() {
  local input="$1"

  # GNU date (Linux)
  if date -d "$input" "+%Y-%m-%d" >/dev/null 2>&1; then
    date -d "$input" "+%Y-%m-%d"
    return 0
  fi

  # BSD date (macOS)
  if date -j -f "%Y-%m-%d" "$input" "+%Y-%m-%d" >/dev/null 2>&1; then
    date -j -f "%Y-%m-%d" "$input" "+%Y-%m-%d"
    return 0
  fi

  echo -e "${RED}Error: Enter a valid date in YYYY-MM-DD format.${RESET}" >&2
  return 1
}

# ------------------------------
# Print table (from stdin lines)
print_table_from_stdin() {
  awk -F'|' '
    BEGIN{
      printf "\n%-4s %-20s %-10s %-12s %-12s\n","ID","TITLE","PRIORITY","DATE","STATUS"
      print "-----------------------------------------------------------"
    }
    {
      priority=$3
      if (priority=="high") priority="\033[0;31mhigh\033[0m"
      else if (priority=="medium") priority="\033[1;33mmedium\033[0m"
      else if (priority=="low") priority="\033[0;32mlow\033[0m"

      status=$5
      if (status=="pending") status="\033[1;33mpending\033[0m"
      else if (status=="in-progress") status="\033[0;36min-progress\033[0m"
      else if (status=="done") status="\033[0;32mdone\033[0m"

      printf "%-4s %-20.20s %-10s %-12s %-12s\n",$1,$2,priority,$4,status
    }'
}

print_table() {
  if [[ ! -s "$TASK_FILE" ]]; then
    echo -e "${YELLOW}No tasks.${RESET}"
    return
  fi
  cat "$TASK_FILE" | print_table_from_stdin
}

# ------------------------------
# Add Task
add_task() {
  echo -e "${CYAN}${BOLD}=== Add Task ===${RESET}"

  # TITLE
  while true; do
    read -r -p "Title: " title
    title=$(echo "$title" | xargs)

    if [[ -z "$title" ]]; then
      echo -e "${RED}Title cannot be empty.${RESET}"
      continue
    fi

    if ! valid_title "$title"; then
      echo -e "${RED}Title must contain letters, numbers and spaces only.${RESET}"
      continue
    fi

    break
  done

  # PRIORITY
  while true; do
    echo "Priority: 1) high 2) medium 3) low"
    read -r -p "Choice: " p
    case "$p" in
      1) priority="high"; break;;
      2) priority="medium"; break;;
      3) priority="low"; break;;
      *) echo -e "${RED}Invalid choice.${RESET}";;
    esac
  done

  # DATE
  while true; do
    read -r -p "Due Date (YYYY-MM-DD): " date_input
    if formatted=$(validate_date "$date_input"); then
      date_input="$formatted"
      break
    else
      echo -e "${RED}Invalid date!${RESET}"
    fi
  done

  id=$(generate_id)
  echo "$id|$title|$priority|$date_input|pending" >> "$TASK_FILE"
  echo -e "${GREEN}Task Added ✔ (ID=$id)${RESET}"
}

# ------------------------------
# List Tasks (with filtering)
list_tasks() {
  echo -e "${CYAN}${BOLD}=== List Tasks ===${RESET}"
  echo "Filter Options: 1) All 2) By Status 3) By Priority"
  read -r -p "Choose: " choice

  case "$choice" in
    1)
      print_table
      ;;
    2)
      echo "Status: 1) pending 2) in-progress 3) done"
      read -r -p "Choice: " s
      case "$s" in
        1) status="pending";;
        2) status="in-progress";;
        3) status="done";;
        *) echo -e "${RED}Invalid status.${RESET}"; return;;
      esac
      awk -F'|' -v s="$status" '$5==s' "$TASK_FILE" | print_table_from_stdin
      ;;
    3)
      echo "Priority: 1) high 2) medium 3) low"
      read -r -p "Choice: " p
      case "$p" in
        1) priority="high";;
        2) priority="medium";;
        3) priority="low";;
        *) echo -e "${RED}Invalid priority.${RESET}"; return;;
      esac
      awk -F'|' -v p="$priority" '$3==p' "$TASK_FILE" | print_table_from_stdin
      ;;
    *)
      echo -e "${RED}Invalid option.${RESET}"
      ;;
  esac
}

# ------------------------------
# Update Task
update_task() {
  echo -e "${CYAN}${BOLD}=== Update Task ===${RESET}"
  print_table

  while true; do
    read -r -p "Enter ID: " id
    grep -q "^$id|" "$TASK_FILE" && break
    echo -e "${RED}ID not found!${RESET}"
  done

  # TITLE
  while true; do
    read -r -p "New Title: " title
    title=$(echo "$title" | xargs)

    if [[ -z "$title" ]]; then
      echo -e "${RED}Title cannot be empty.${RESET}"
      continue
    fi

    if ! valid_title "$title"; then
      echo -e "${RED}Title must contain letters, numbers and spaces only.${RESET}"
      continue
    fi

    break
  done

  # PRIORITY
  while true; do
    echo "Priority: 1) high 2) medium 3) low"
    read -r -p "Choice: " p
    case "$p" in
      1) priority="high"; break;;
      2) priority="medium"; break;;
      3) priority="low"; break;;
      *) echo -e "${RED}Invalid choice.${RESET}";;
    esac
  done

  # DATE
  while true; do
    read -r -p "New Due Date (YYYY-MM-DD): " date_input
    if formatted=$(validate_date "$date_input"); then
      date_input="$formatted"
      break
    else
      echo -e "${RED}Invalid date!${RESET}"
    fi
  done

  # STATUS
  while true; do
    echo "Status: 1) pending 2) in-progress 3) done"
    read -r -p "Choice: " s
    case "$s" in
      1) status="pending"; break;;
      2) status="in-progress"; break;;
      3) status="done"; break;;
      *) echo -e "${RED}Invalid choice.${RESET}";;
    esac
  done

  # Replace line (sed in-place)
  sed -i.bak "s#^$id|.*#$id|$title|$priority|$date_input|$status#" "$TASK_FILE"
  rm -f "$TASK_FILE.bak"

  echo -e "${GREEN}Updated ✔${RESET}"
}

# ------------------------------
# Delete Task
delete_task() {
  echo -e "${CYAN}${BOLD}=== Delete Task ===${RESET}"
  print_table

  while true; do
    read -r -p "Enter ID: " id
    grep -q "^$id|" "$TASK_FILE" && break
    echo -e "${RED}ID not found!${RESET}"
  done

  read -r -p "Are you sure? y/n: " c
  [[ "$c" =~ ^[Yy]$ ]] && {
    sed -i.bak "/^$id|/d" "$TASK_FILE"
    rm -f "$TASK_FILE.bak"
    echo -e "${GREEN}Deleted ✔${RESET}"
  } || echo -e "${YELLOW}Cancelled${RESET}"
}

# ------------------------------
# Search Task (Title only)
search_task() {
  echo -e "${CYAN}${BOLD}=== Search (Title) ===${RESET}"
  read -r -p "Enter keyword to search in TITLE: " key
  [[ -n "$key" ]] || { echo -e "${RED}Keyword cannot be empty.${RESET}"; return; }

  awk -F'|' -v k="$key" 'BEGIN{IGNORECASE=1} $2 ~ k {print $0}' "$TASK_FILE" | print_table_from_stdin
}

# ------------------------------
# Reports
task_summary() {
  echo -e "${CYAN}${BOLD}=== Task Summary ===${RESET}"
  awk -F'|' '
    { c[$5]++ }
    END {
      print "Pending     :", c["pending"]+0
      print "In-Progress :", c["in-progress"]+0
      print "Done        :", c["done"]+0
    }
  ' "$TASK_FILE"
}

overdue_tasks() {
  echo -e "${CYAN}${BOLD}=== Overdue Tasks ===${RESET}"
  today=$(date +%F)
  echo -e "${YELLOW}Today: $today${RESET}"
  awk -F'|' -v t="$today" '$4 < t && $5 != "done" {print $0}' "$TASK_FILE" | print_table_from_stdin
}

priority_report() {
  echo -e "${CYAN}${BOLD}=== Priority Report ===${RESET}"
  for p in high medium low; do
    echo -e "${BLUE}--- $p ---${RESET}"
    awk -F'|' -v pr="$p" '$3==pr {print $0}' "$TASK_FILE" | print_table_from_stdin
    echo
  done
}

reports_menu() {
  echo -e "${CYAN}${BOLD}=== Reports Menu ===${RESET}"
  echo "1) Task Summary"
  echo "2) Overdue Tasks"
  echo "3) Priority Report"
  read -r -p "Choice: " r
  case "$r" in
    1) task_summary ;;
    2) overdue_tasks ;;
    3) priority_report ;;
    *) echo -e "${RED}Invalid option.${RESET}" ;;
  esac
}

# ------------------------------
# MAIN MENU
while true; do
  echo
  echo -e "${CYAN}${BOLD}==== MINI TASK MANAGER ====${RESET}"
  echo "1) Add Task"
  echo "2) List Tasks"
  echo "3) Update Task"
  echo "4) Delete Task"
  echo "5) Search"
  echo "6) Reports"
  echo "7) Exit"
  read -r -p "Choose: " c

  case "$c" in
    1) add_task; pause ;;
    2) list_tasks; pause ;;
    3) update_task; pause ;;
    4) delete_task; pause ;;
    5) search_task; pause ;;
    6) reports_menu; pause ;;
    7) echo -e "${GREEN}Bye 👋${RESET}"; exit ;;
    *) echo -e "${RED}Invalid option${RESET}" ;;
  esac
done
