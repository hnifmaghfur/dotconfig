export EDITOR=vim
export VISUAL=vim

export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/.npm-global/bin:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export pyenv_ROOT="$PYENV_ROOT"
export RBENV_ROOT="$HOME/.rbenv"
export NVM_DIR="$HOME/.nvm"

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_OPTS='--preview "bat {}"'
export FZF_ALT_C_OPTS='--preview "eza --tree --color=always {} | head -20"'