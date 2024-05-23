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
alias reload="source ~/.zshrc"

tere() {
    local result=$(command tere "$@")
    [ -n "$result" ] && cd -- "$result"
}

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

# Load OS-specific config
source "$DOTFILES/os/zshload.zsh"
source "$(brew --prefix asdf)/libexec/asdf.sh"
source $HOME/.asdf/plugins/golang/set-env.zsh

# Load secrets
source ~/.zshenv

# Start in a tmux session by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

