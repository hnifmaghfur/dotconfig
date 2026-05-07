#!/bin/bash
# Pure bash test runner for dotfiles.
# Discovers all test_*.sh files in the tests/ directory and runs every
# function named test_* defined in them. Each test is executed in a
# subshell so failures are isolated.
#
# Usage: bash tests/run_tests.sh

TESTS_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$TESTS_DIR/.." && pwd)"
export REPO_ROOT

PASSED=0
FAILED=0
FAILED_TESTS=()

if [ -t 1 ]; then
  RED=$'\033[0;31m'
  GREEN=$'\033[0;32m'
  YELLOW=$'\033[0;33m'
  NC=$'\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  NC=''
fi

# ---------- assertion helpers ----------

assert_equals() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-}"
  if [ "$expected" != "$actual" ]; then
    printf '  assertion failed: expected %q, got %q %s\n' \
      "$expected" "$actual" "$msg" >&2
    return 1
  fi
}

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local msg="${3:-}"
  if [[ "$haystack" != *"$needle"* ]]; then
    printf '  assertion failed: output does not contain %q %s\n' \
      "$needle" "$msg" >&2
    printf '  actual output:\n%s\n' "$haystack" >&2
    return 1
  fi
}

assert_exit_code() {
  local expected="$1"
  local actual="$2"
  local msg="${3:-}"
  if [ "$expected" != "$actual" ]; then
    printf '  assertion failed: expected exit code %s, got %s %s\n' \
      "$expected" "$actual" "$msg" >&2
    return 1
  fi
}

# ---------- runner ----------

run_test() {
  local test_fn="$1"
  local output
  local rc
  output="$(set -e; "$test_fn" 2>&1)"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    printf '%sPASS%s: %s\n' "$GREEN" "$NC" "$test_fn"
    PASSED=$((PASSED + 1))
  else
    printf '%sFAIL%s: %s\n' "$RED" "$NC" "$test_fn"
    if [ -n "$output" ]; then
      printf '%s\n' "$output" | sed 's/^/    /'
    fi
    FAILED=$((FAILED + 1))
    FAILED_TESTS+=("$test_fn")
  fi
}

shopt -s nullglob
for test_file in "$TESTS_DIR"/test_*.sh; do
  printf '%s--- %s ---%s\n' "$YELLOW" "$(basename "$test_file")" "$NC"
  # shellcheck disable=SC1090
  source "$test_file"
  test_fns=$(declare -F | awk '{print $3}' | grep '^test_' || true)
  for fn in $test_fns; do
    run_test "$fn"
  done
  for fn in $test_fns; do
    unset -f "$fn"
  done
  printf '\n'
done
shopt -u nullglob

printf '%s passed, %s failed\n' "$PASSED" "$FAILED"

if [ "$FAILED" -gt 0 ]; then
  printf '%sFailed tests:%s\n' "$RED" "$NC"
  for t in "${FAILED_TESTS[@]}"; do
    printf '  - %s\n' "$t"
  done
  exit 1
fi
exit 0
