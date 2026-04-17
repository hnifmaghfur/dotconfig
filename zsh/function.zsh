preexec() {
  local cmd="$1"
  local alias_val="$(alias "$cmd" 2>/dev/null)"
  if [[ -n "$alias_val" ]]; then
    echo "${alias_val#alias }"
  fi
}

th() {
  cat <<'EOF'
# Tmux Shortcuts

## Default (configured)
  C-Space         - prefix key (sebelum tekan shortcut lain)
  C-Space + d    - detach dari session
  C-Space + c    - buat window baru
  C-Space + ,    - rename window
  C-Space + &    - kill window
  C-Space + x    - kill pane
  C-Space + n    - next window
  C-Space + p    - previous window
  C-Space + 0-9 - ke window tertentu
  C-Space + Left - move window left
  C-Space + Right- move window right

## tmux-pain-control (Navigation)
  C-Space + h    - select pane kiri
  C-Space + j    - select pane bawah
  C-Space + k    - select pane atas
  C-Space + l    - select pane kanan
  C-Space + C-h   - select pane kiri
  C-Space + C-j   - select pane bawah
  C-Space + C-k   - select pane atas
  C-Space + C-l   - select pane kanan

## tmux-pain-control (Resize)
  C-Space + H    - resize pane kiri 5 cells
  C-Space + J    - resize pane bawah 5 cells
  C-Space + K    - resize pane atas 5 cells
  C-Space + L    - resize pane kanan 5 cells

## tmux-pain-control (Split)
  C-Space + |    - split horizontal (kiri-kanan)
  C-Space + -    - split vertical (atas-bawah)
  C-Space + \    - split full width horizontal
  C-Space + _    - split full width vertical

## tmux-pain-control (Swap Window)
  C-Space + <    - move window ke kiri
  C-Space + >    - move window ke kanan

## tmux-yank (Copy)
  C-Space + y    - copy command line ke clipboard
  C-Space + Y    - copy current directory
  Copy mode: y   - copy selection ke clipboard
  Copy mode: Y   - paste selection

## tmux-cowboy (Kill Process)
  C-Space + *    - kill process di pane sekarang (kill -9)

## vim-tmux-navigator (Vim Integration)
  C-h           - navigate left (tanpa prefix)
  C-j           - navigate down (tanpa prefix)
  C-k           - navigate up (tanpa prefix)
  C-l           - navigate right (tanpa prefix)
  C-\           - previous split

EOF
}