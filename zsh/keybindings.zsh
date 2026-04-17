bindkey '^[[D' backward-word
bindkey '^[[C' forward-word
bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word

bindkey -e '^[[1;5D' backward-word
bindkey -e '^[[1;5C' forward-word
bindkey -e '^[[1;5A' up-line-or-history
bindkey -e '^[[1;5B' down-line-or-history

bindkey '^X^Z' universal-argument
bindkey '^Z' push-line-or-edit

autoload -U pick-web-browser
autoload -U url-quote-magic

zstyle ':url:' web-browser 'firefox'

bindkey '^pl' up-line-or-history
bindkey '^pn' down-line-or-history

wezterm-pane-left() { wezterm cli activate-pane-direction left }
wezterm-pane-right() { wezterm cli activate-pane-direction right }
wezterm-pane-up() { wezterm cli activate-pane-direction up }
wezterm-pane-down() { wezterm cli activate-pane-direction down }

wezterm-split-vertical() { wezterm cli split-pane --vertical }
wezterm-split-horizontal() { wezterm cli split-pane --horizontal }

zle -N wezterm-pane-left
zle -N wezterm-pane-right
zle -N wezterm-pane-up
zle -N wezterm-pane-down
zle -N wezterm-split-vertical
zle -N wezterm-split-horizontal

bindkey '^h' wezterm-pane-left
bindkey '^j' wezterm-pane-down
bindkey '^k' wezterm-pane-up
bindkey '^l' wezterm-pane-right

bindkey '^v' wezterm-split-vertical
bindkey '^b' wezterm-split-horizontal