export DOTFILES="$HOME/.dotfiles"

source "$DOTFILES/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

export EDITOR=nvim
export GPG_TTY=$(tty)

# History search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Aliases and convenient functions
alias gst="git status"
alias gaa="git add ."

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
if [[ ! -a ~/.zshenv ]]; then
   touch ~/.zshenv 
fi
source ~/.zshenv

# Start in a tmux session by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi

eval "$(starship init zsh)"
