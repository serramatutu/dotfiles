export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(
  git
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-vi-mode
)

# Update Oh My Zsh automatically every 13 days
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

source "$ZSH/oh-my-zsh.sh"

export DOTFILES="$HOME/.dotfiles"

export EDITOR=nvim
export GPG_TTY=$(tty)

# History search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Aliases
alias dotfiles="cd $DOTFILES"
alias zshconfig="nvim ~/.zshrc"
alias venv="source .venv/bin/activate"
alias ls="lsd -l"

tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

# Go
export PATH="$PATH:$HOME/go/bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load OS-specific config
source "$DOTFILES/os/zshload.zsh"

# Load secrets
source ~/.zshenv

# Start in a tmux session by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
