if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  source "$DOTFILES/os/linux/zshload.zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  source "$DOTFILES/os/macos/zshload.zsh"
fi
