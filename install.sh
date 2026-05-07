#!/bin/bash

# Use BASH_SOURCE so DOTDIR is correct even when this file is sourced
# (e.g. from the test runner).
DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

# ---------- component discovery ----------

# Print the name of every subdirectory under DOTDIR that contains an
# install.sh script, one per line, sorted alphabetically.
discover_components() {
  local dir
  local components=()
  for dir in "$DOTDIR"/*/; do
    if [ -f "${dir}install.sh" ]; then
      components+=("$(basename "$dir")")
    fi
  done
  if [ ${#components[@]} -eq 0 ]; then
    return 0
  fi
  printf '%s\n' "${components[@]}" | LC_ALL=C sort
}

# ---------- interactive menu ----------

# Print a numbered menu for the given component list.
# Usage: show_menu zsh tmux wezterm
show_menu() {
  local components=("$@")
  local i=1
  printf '\n'
  printf 'Available components:\n'
  local c
  for c in "${components[@]}"; do
    printf '  %d) %s\n' "$i" "$c"
    i=$((i + 1))
  done
  printf '  a) all\n'
  printf '  q) quit\n'
  printf '\n'
}

# Parse a selection string against a list of components.
# Usage: parse_selection "1,3" comp1 comp2 comp3 ...
# Prints selected component names (one per line) to stdout.
# Exit codes:
#   0 - valid selection
#   1 - invalid input (error printed to stderr)
#   2 - user requested quit
parse_selection() {
  local input="$1"
  shift
  local components=("$@")
  local count=${#components[@]}

  # Trim leading/trailing whitespace.
  input="${input#"${input%%[![:space:]]*}"}"
  input="${input%"${input##*[![:space:]]}"}"

  local lower
  lower="$(printf '%s' "$input" | tr '[:upper:]' '[:lower:]')"

  if [ "$lower" = "q" ] || [ "$lower" = "quit" ]; then
    return 2
  fi

  if [ "$lower" = "a" ] || [ "$lower" = "all" ]; then
    if [ "$count" -eq 0 ]; then
      echo "Error: no components available" >&2
      return 1
    fi
    printf '%s\n' "${components[@]}"
    return 0
  fi

  if [ -z "$input" ]; then
    echo "Error: empty selection" >&2
    return 1
  fi

  # Normalise commas to spaces so "1,3" and "1 3" both work.
  local normalized="${input//,/ }"

  local selected=()
  local token
  for token in $normalized; do
    if ! [[ "$token" =~ ^[0-9]+$ ]]; then
      echo "Error: invalid selection '$token'" >&2
      return 1
    fi
    if [ "$token" -lt 1 ] || [ "$token" -gt "$count" ]; then
      echo "Error: selection $token out of range (1-$count)" >&2
      return 1
    fi
    local name="${components[$((token - 1))]}"
    # Deduplicate so "1 1" → one entry.
    local found=0 s
    for s in "${selected[@]}"; do
      if [ "$s" = "$name" ]; then
        found=1
        break
      fi
    done
    if [ "$found" -eq 0 ]; then
      selected+=("$name")
    fi
  done

  if [ ${#selected[@]} -eq 0 ]; then
    echo "Error: empty selection" >&2
    return 1
  fi

  printf '%s\n' "${selected[@]}"
}

# Show a summary of the components that will be installed and ask the
# user to confirm. Returns 0 on "y"/"yes" (case insensitive), 1 otherwise.
# Input is read from stdin so tests can pipe responses in.
# Usage: confirm_selection zsh tmux
confirm_selection() {
  local components=("$@")
  printf '\n'
  printf 'The following will be installed:\n'
  local c
  for c in "${components[@]}"; do
    printf '  - %s\n' "$c"
  done
  printf '\n'
  printf 'Proceed? [y/N]: '
  local answer
  read -r answer
  local lower
  lower="$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')"
  case "$lower" in
    y|yes) return 0 ;;
    *)     return 1 ;;
  esac
}

# ---------- installation + summary ----------

# Global arrays populated by main() loop so print_summary can render them.
SUCCESS=()
FAILED=()

# Run a single component's install.sh. Returns 0 on success, 1 on
# failure (or missing script). Does not propagate `set -e` because the
# `if` construct disables it for the condition.
# Usage: install_component eza
install_component() {
  local name="$1"
  local script="$DOTDIR/$name/install.sh"
  if [ ! -f "$script" ]; then
    printf 'Error: install script not found: %s\n' "$script" >&2
    return 1
  fi
  printf '\n>>> Installing %s...\n' "$name"
  if bash "$script"; then
    return 0
  fi
  return 1
}

# Print a ✓/✗ summary table from the SUCCESS and FAILED arrays.
# Uses ANSI colours only when stdout is a TTY.
print_summary() {
  local green='' red='' nc=''
  if [ -t 1 ]; then
    green=$'\033[0;32m'
    red=$'\033[0;31m'
    nc=$'\033[0m'
  fi

  printf '\n'
  printf 'Installation Summary:\n'
  local c
  for c in "${SUCCESS[@]}"; do
    printf '  %s✓%s %s\n' "$green" "$nc" "$c"
  done
  for c in "${FAILED[@]}"; do
    printf '  %s✗%s %s\n' "$red" "$nc" "$c"
  done
  printf '\n'
  printf '%d succeeded, %d failed\n' "${#SUCCESS[@]}" "${#FAILED[@]}"
}

# ---------- base install + orchestrator ----------

install_base_linux() {
  sudo apt update
  sudo apt install -y git curl wget build-essential
}

install_base_macos() {
  brew install git curl wget
}

# Read a selection from the user and populate `selected` array.
# Loops on invalid input, exits the whole program with 0 on quit.
# Requires `components` to be set in the caller's scope.
_prompt_menu_loop() {
  local input output rc line
  while true; do
    show_menu "${components[@]}"
    printf 'Select components [1-%d, a=all, q=quit]: ' "${#components[@]}"
    if ! read -r input; then
      # EOF on stdin (e.g. piped-in input exhausted) → treat as quit.
      printf '\n'
      echo "Cancelled."
      exit 0
    fi

    rc=0
    output="$(parse_selection "$input" "${components[@]}" 2>&1)" || rc=$?
    case "$rc" in
      0)
        selected=()
        while IFS= read -r line; do
          [ -n "$line" ] && selected+=("$line")
        done <<<"$output"
        return 0
        ;;
      2)
        echo "Cancelled."
        exit 0
        ;;
      *)
        printf '%s\n' "$output" >&2
        ;;
    esac
  done
}

main() {
  set -e

  # DOTCONFIG_TEST_MODE=1 skips side effects (base install, symlink)
  # so tests can exercise the interactive flow without touching the
  # host system.
  if [ "${DOTCONFIG_TEST_MODE:-0}" != "1" ]; then
    if [ "$OS" = "Linux" ]; then
      install_base_linux
    elif [ "$OS" = "Darwin" ]; then
      install_base_macos
    fi
    ln -sf "$DOTDIR" ~/.dotfiles
  fi

  local components=()
  local line
  while IFS= read -r line; do
    [ -n "$line" ] && components+=("$line")
  done < <(discover_components)

  if [ ${#components[@]} -eq 0 ]; then
    echo "No installable components found in $DOTDIR" >&2
    exit 1
  fi

  local selected=()
  _prompt_menu_loop

  if ! confirm_selection "${selected[@]}"; then
    echo "Cancelled."
    exit 0
  fi

  SUCCESS=()
  FAILED=()
  local c
  for c in "${selected[@]}"; do
    if install_component "$c"; then
      SUCCESS+=("$c")
    else
      FAILED+=("$c")
    fi
  done

  print_summary

  if [ ${#FAILED[@]} -gt 0 ]; then
    exit 1
  fi
  exit 0
}

# Only run when executed directly (not when sourced by tests).
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
