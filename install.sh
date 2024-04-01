#!/bin/sh

# This file contains general installs that don't need extra files.


# Rust
echo "Install Rust"
curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo "Install tere"
tere --version || cargo install tere

echo "Install fd-find"
fd --version || cargo install fd-find

echo "Install ripgrep (used by nvim-telescope)"
ripgrep --version || cargo install ripgrep

echo "Install bat"
bat --version || cargo install bat

echo "Install pyenv"
curl --proto "=https" --tlsv1.2 -sSf https://pyenv.run | bash

echo "Install nvm"
curl --proto "=https" --tlsv1.2 -sSf https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

echo "Install act"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | bash -s -- -b /usr/local/bin

echo "Install glow (requires Golang)"
if ! [ -x "$(command -v go --version)" ]; then
  echo "Skipping glow installation. Go is unavailable."
else
  go install github.com/charmbracelet/glow@latest
fi


echo "Install lazygit (requires Golang)"
if ! [ -x "$(command -v go --version)" ]; then
  echo "Skipping lazygit installation. Go is unavailable."
else
  go install github.com/jesseduffield/lazygit@latest
fi

sh ./alacritty/install.sh
sh ./zsh/install.sh
sh ./lsd/install.sh
sh ./nvim/install.sh
sh ./tmux/install.sh

