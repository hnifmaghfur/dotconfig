preexec() {
  local cmd="$1"
  local alias_val="$(alias "$cmd" 2>/dev/null)"
  if [[ -n "$alias_val" ]]; then
    echo "${alias_val#alias }"
  fi
}