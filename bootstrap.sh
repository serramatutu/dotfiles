#!/bin/bash

echo "Initializing submodules"
git submodule update --init --recursive > /dev/null

export DOTFILES="$HOME/.dotfiles"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  . "$DOTFILES/os/linux/bootstrap.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  . "$DOTFILES/os/macos/bootstrap.sh"
fi

. packages/asdf/bootstrap.sh
. packages/rust/bootstrap.sh
. packages/golang/bootstrap.sh
. packages/python/bootstrap.sh

mkdir -p ~/.local/bin/
ln -sf $DOTFILES/home/* ~/
ln -sf $DOTFILES/.local/bin/* ~/.local/
ln -sf $DOTFILES/.local/share/* ~/.local/share/
ln -sf $DOTFILES/.config/* ~/.config/

git config --global include.path "~/.config/git/.gitconfig" 
