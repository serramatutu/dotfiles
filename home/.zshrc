export DOTFILES="$HOME/.dotfiles"

autoload -U compinit; compinit
source "$DOTFILES/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-fzf-history-search/zsh-fzf-history-search.plugin.zsh"
source "$DOTFILES/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
source "$DOTFILES/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"

# long history
HISTSIZE=9999
SAVEHIST=$HISTSIZE

export EDITOR=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export GPG_TTY=$(tty)
export GIT_USER="serramatutu"
export FZF_DEFAULT_OPTS='--height "~100%" --layout reverse --border --margin=1 --padding=1'
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
export PATH="$PATH:$HOME/.local/bin"

# asdf VM stuff
export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# Git aliases
alias lg="lazygit"
alias gst="git status"
alias ga="git add"
alias gaa="git add ."
alias gr="git reset"
alias gc="git commit"
alias gfix="git commit --amend --no-edit"
alias gpf="git push --force-with-lease"
alias gl="git log"
alias gll="git log --oneline"
alias glt="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset%n' --abbrev-commit --date=relative --branches"
gp() {
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  git push $@ origin $current_branch
}
gb() {
  local branch="$1"
  if [ "$branch" = "" ]; then
    branch=$(git branch | cut -c 3- | fzf)
  fi

  git switch "$branch"
}
alias gd="git diff --cached"
alias gbp="git branch --merged | egrep -v '(^\*|master|main)' | xargs git branch -d"

# nvim
alias vim="nvim"
alias vi="nvim"

# --help messages with syntax highlighting
help() {
    "$@" --help 2>&1 | bat --plain --language=help
}
alias -g -- -h='-h 2>&1 | bat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'

# jump
j() {
  local output=$(jump "$@")
  echo "$output"
  local dir="$(echo -n "$output" | head -n 1)"
  eval cd "$dir"
}

alias venv="source .venv/bin/activate"
alias ls="lsd -l"

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

rm() {
  local last_arg=${@[-1]}
  if [ "$last_arg" = "$HOME" ]; then
    echo "Avoiding accidental rm over home directory."
    echo "If you REALLY want to do that, run "
    echo "  command rm $@"
    return 1
  else
    command rm "$@"
  fi
}

# search for a session and kill it
tmux-kill() {
  local selected=$(tmux list-sessions | grep -oE "^[0-9A-Za-z]+" | fzf)
  tmux kill-session -t "$selected"
}

# ripgrep
export RIPGREP_CONFIG_PATH=$HOME/.config/ripgrep/ripgreprc


# Load OS-specific config
source "$DOTFILES/os/zshload.zsh"
source $HOME/.asdf/plugins/golang/set-env.zsh

# Add custom scripts and executables to path
export PATH="$PATH:$HOME/bin"


# Start in a tmux session by default
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi


# Initialize completions
eval "$(starship init zsh)"
source <(fzf --zsh)

