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

export ASDF_DATA_DIR="$HOME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
source "$HOME/.cargo/env"

alias gl="git log --oneline"
alias gst="git status"
alias ga="git add"
alias gr="git reset"
alias gaa="git add ."

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

# Early exit if loading from VSCode to allow it to load path
if [ "${TERM_PROGRAM}" = "vscode" ]; then
  return
fi

# Initialize completions
eval "$(starship init zsh)"
source <(fzf --zsh)

