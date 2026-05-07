#!/bin/bash
# Tests for install.sh and related component install scripts.
#
# REPO_ROOT is exported by run_tests.sh.

test_script_exists_and_executable() {
  [ -f "$REPO_ROOT/install.sh" ] || {
    echo "install.sh not found at $REPO_ROOT/install.sh"
    return 1
  }
  [ -x "$REPO_ROOT/install.sh" ] || {
    echo "install.sh is not executable"
    return 1
  }
}

test_eza_install_script_exists() {
  [ -f "$REPO_ROOT/eza/install.sh" ] || {
    echo "eza/install.sh not found"
    return 1
  }
  [ -x "$REPO_ROOT/eza/install.sh" ] || {
    echo "eza/install.sh is not executable"
    return 1
  }
  local content
  content="$(cat "$REPO_ROOT/eza/install.sh")"
  assert_contains "$content" "command -v eza" "eza script must be idempotent"
}

test_discover_components_lists_all_dirs() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(discover_components)"
  assert_contains "$output" "eza"
  assert_contains "$output" "tmux"
  assert_contains "$output" "wezterm"
  assert_contains "$output" "zsh"
}

test_discover_components_is_sorted() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output expected
  output="$(discover_components)"
  expected="$(printf '%s\n' "$output" | LC_ALL=C sort)"
  assert_equals "$expected" "$output" "components must be alphabetically sorted"
}

test_show_menu_formats_numbered_list() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(show_menu foo bar)"
  assert_contains "$output" "Available components:"
  assert_contains "$output" "1) foo"
  assert_contains "$output" "2) bar"
  assert_contains "$output" "a) all"
  assert_contains "$output" "q) quit"
}

test_show_menu_empty_components() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(show_menu)"
  assert_contains "$output" "a) all"
  assert_contains "$output" "q) quit"
}

# ---------- parse_selection ----------

_components_fixture=(eza tmux wezterm zsh)

test_parse_single_number() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "1" "${_components_fixture[@]}")"
  assert_equals "eza" "$output"
}

test_parse_last_number() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "4" "${_components_fixture[@]}")"
  assert_equals "zsh" "$output"
}

test_parse_space_separated() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "1 3" "${_components_fixture[@]}")"
  assert_equals $'eza\nwezterm' "$output"
}

test_parse_comma_separated() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "1,3" "${_components_fixture[@]}")"
  assert_equals $'eza\nwezterm' "$output"
}

test_parse_comma_with_spaces() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "1, 3" "${_components_fixture[@]}")"
  assert_equals $'eza\nwezterm' "$output"
}

test_parse_all_keyword() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "a" "${_components_fixture[@]}")"
  assert_equals $'eza\ntmux\nwezterm\nzsh' "$output"
}

test_parse_all_full_word() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "all" "${_components_fixture[@]}")"
  assert_equals $'eza\ntmux\nwezterm\nzsh' "$output"
}

test_parse_all_uppercase() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "ALL" "${_components_fixture[@]}")"
  assert_equals $'eza\ntmux\nwezterm\nzsh' "$output"
}

test_parse_quit_exits_with_code_2() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  parse_selection "q" "${_components_fixture[@]}" > /dev/null 2>&1 || rc=$?
  assert_exit_code 2 "$rc"
}

test_parse_quit_full_word() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  parse_selection "quit" "${_components_fixture[@]}" > /dev/null 2>&1 || rc=$?
  assert_exit_code 2 "$rc"
}

test_parse_invalid_text_returns_1() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  parse_selection "xyz" "${_components_fixture[@]}" > /dev/null 2>&1 || rc=$?
  assert_exit_code 1 "$rc"
}

test_parse_out_of_range_returns_1() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  parse_selection "99" "${_components_fixture[@]}" > /dev/null 2>&1 || rc=$?
  assert_exit_code 1 "$rc"
}

test_parse_empty_returns_1() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  parse_selection "" "${_components_fixture[@]}" > /dev/null 2>&1 || rc=$?
  assert_exit_code 1 "$rc"
}

test_parse_dedups_duplicates() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output
  output="$(parse_selection "1 1 2" "${_components_fixture[@]}")"
  assert_equals $'eza\ntmux' "$output"
}

# ---------- confirm_selection ----------

test_confirm_yes_returns_0() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  echo "y" | confirm_selection zsh tmux > /dev/null 2>&1 || rc=$?
  assert_exit_code 0 "$rc"
}

test_confirm_yes_uppercase_returns_0() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  echo "Y" | confirm_selection zsh tmux > /dev/null 2>&1 || rc=$?
  assert_exit_code 0 "$rc"
}

test_confirm_yes_word_returns_0() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  echo "yes" | confirm_selection zsh tmux > /dev/null 2>&1 || rc=$?
  assert_exit_code 0 "$rc"
}

test_confirm_no_returns_1() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  echo "n" | confirm_selection zsh tmux > /dev/null 2>&1 || rc=$?
  assert_exit_code 1 "$rc"
}

test_confirm_empty_returns_1() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local rc=0
  echo "" | confirm_selection zsh tmux > /dev/null 2>&1 || rc=$?
  assert_exit_code 1 "$rc"
}

test_confirm_shows_components() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local output rc=0
  output="$(echo "n" | confirm_selection zsh tmux 2>&1)" || rc=$?
  assert_contains "$output" "zsh"
  assert_contains "$output" "tmux"
  assert_contains "$output" "Proceed?"
}

# ---------- install_component ----------

_make_fake_dotdir() {
  local base="$1"
  mkdir -p "$base/testok" "$base/testfail"
  cat > "$base/testok/install.sh" <<'EOF'
#!/bin/bash
echo "testok ran"
exit 0
EOF
  cat > "$base/testfail/install.sh" <<'EOF'
#!/bin/bash
echo "testfail ran"
exit 1
EOF
  chmod +x "$base/testok/install.sh" "$base/testfail/install.sh"
}

test_install_component_success() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local tmp
  tmp="$(mktemp -d)"
  _make_fake_dotdir "$tmp"
  DOTDIR="$tmp"
  local rc=0
  install_component testok > /dev/null 2>&1 || rc=$?
  rm -rf "$tmp"
  assert_exit_code 0 "$rc"
}

test_install_component_failure() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local tmp
  tmp="$(mktemp -d)"
  _make_fake_dotdir "$tmp"
  DOTDIR="$tmp"
  local rc=0
  install_component testfail > /dev/null 2>&1 || rc=$?
  rm -rf "$tmp"
  assert_exit_code 1 "$rc"
}

test_install_component_missing() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local tmp
  tmp="$(mktemp -d)"
  DOTDIR="$tmp"
  local rc=0
  install_component nonexistent > /dev/null 2>&1 || rc=$?
  rm -rf "$tmp"
  assert_exit_code 1 "$rc"
}

test_install_component_does_not_propagate_set_e() {
  # Simulate the main loop under `set -e`. If install_component leaked
  # a non-zero exit, the subshell would exit before the echo below.
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  local tmp
  tmp="$(mktemp -d)"
  _make_fake_dotdir "$tmp"
  DOTDIR="$tmp"
  local marker
  marker="$(
    set -e
    if install_component testfail > /dev/null 2>&1; then
      :
    fi
    echo "still alive"
  )"
  rm -rf "$tmp"
  assert_equals "still alive" "$marker"
}

# ---------- print_summary ----------

test_print_summary_shows_success_and_failed() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  SUCCESS=(foo bar)
  FAILED=(baz)
  local output
  output="$(print_summary)"
  assert_contains "$output" "✓"
  assert_contains "$output" "foo"
  assert_contains "$output" "bar"
  assert_contains "$output" "✗"
  assert_contains "$output" "baz"
  assert_contains "$output" "2 succeeded, 1 failed"
}

test_print_summary_all_success() {
  # shellcheck disable=SC1091
  source "$REPO_ROOT/install.sh"
  SUCCESS=(only)
  FAILED=()
  local output
  output="$(print_summary)"
  assert_contains "$output" "✓ only"
  assert_contains "$output" "1 succeeded, 0 failed"
}

# ---------- end-to-end main() ----------

test_end_to_end_quit_exits_cleanly() {
  local rc=0
  local output
  output="$(DOTCONFIG_TEST_MODE=1 bash "$REPO_ROOT/install.sh" <<<"q" 2>&1)" || rc=$?
  assert_exit_code 0 "$rc"
  assert_contains "$output" "Cancelled."
}

test_end_to_end_cancel_at_confirm() {
  local rc=0
  local output
  output="$(DOTCONFIG_TEST_MODE=1 bash "$REPO_ROOT/install.sh" <<<"$(printf '1\nn\n')" 2>&1)" || rc=$?
  assert_exit_code 0 "$rc"
  assert_contains "$output" "The following will be installed"
  assert_contains "$output" "Cancelled."
}

test_end_to_end_invalid_then_quit_reprompts() {
  local rc=0
  local output
  output="$(DOTCONFIG_TEST_MODE=1 bash "$REPO_ROOT/install.sh" <<<"$(printf 'xyz\nq\n')" 2>&1)" || rc=$?
  assert_exit_code 0 "$rc"
  assert_contains "$output" "invalid selection"
  assert_contains "$output" "Cancelled."
}

test_end_to_end_menu_contains_all_components() {
  local rc=0
  local output
  output="$(DOTCONFIG_TEST_MODE=1 bash "$REPO_ROOT/install.sh" <<<"q" 2>&1)" || rc=$?
  assert_contains "$output" "eza"
  assert_contains "$output" "tmux"
  assert_contains "$output" "wezterm"
  assert_contains "$output" "zsh"
  assert_contains "$output" "a) all"
  assert_contains "$output" "q) quit"
}
