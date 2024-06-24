export DOTFILES="$HOME/.dotfiles"

autoload -U compinit; compinit
source "$DOTFILES/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$DOTFILES/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export GPG_TTY=$(tty)
export GIT_USER="serramatutu"

# History search
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Git aliases
alias lg="lazygit"
alias gst="git status"
alias gaa="git add ."
alias gc="git commit"
alias gfix="git commit --amend --no-edit"
alias gpf="git push --force-with-lease"
alias gd="git diff --name-only --relative --diff-filter=d | xargs bat --diff"
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

# --help messages with syntax highlighting
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

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

# easy find and replace
replace() {
  if [ "$#" -ne 3 ]; then
    echo "Bad arguments.\n\nUSAGE: replace FILES_GLOB OLD_PAT NEW_PAT"
    exit 1
  fi

  local glob="$1"
  local old="$2"
  local new="$3"

  find "$glob" -type f -exec sed -i "" "s/$old/$new/g" {} \;
}

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc

# Load OS-specific config
source "$DOTFILES/os/zshload.zsh"
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
