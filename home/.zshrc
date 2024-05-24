export DOTFILES="$HOME/.dotfiles"

autoload -U compinit; compinit
source "$DOTFILES/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$DOTFILES/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

export EDITOR=nvim
export GPG_TTY=$(tty)
export GIT_USER="serramatutu"

# History search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Aliases and convenient functions
alias lg="lazygit"
alias gst="git status"
alias gaa="git add ."
alias gc="git commit"
alias gca="git commit --amend --no-edit"
gp() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  git push $@ origin $current_branch
}
gb() {
  arg=$1

  if [ `git rev-parse --verify $arg 2>/dev/null` ]; then
    git checkout $arg
  elif [ `git rev-parse --verify $GIT_USER/$arg 2>/dev/null` ]; then 
    git checkout $GIT_USER/$arg
  else
    git append $GIT_USER/$arg
  fi
}
alias gpf="git push --force-with-lease"

alias dotfiles="cd $DOTFILES"
alias zshconfig="nvim ~/.zshrc"
alias venv="source .venv/bin/activate"
alias ls="lsd -l"
alias reload="source ~/.zshrc"

# smart cd using tere
smartcd() {
  if [ "$#" -eq "0" ]; then
    local result=$(tere) 
    [ -n "$result" ] && cd -- "$result"
  else
    cd -- "$@"
  fi
}
alias cd="smartcd"

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
source <(fzf --zsh)
