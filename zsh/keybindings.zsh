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