#!/bin/bash

echo "Running MacOS bootstrap"

. "$DOTFILES/packages/homebrew/bootstrap.sh"

skhd --install-service
skhd --start-service

yabai --install-service
yabai --start-service

ln -s $DOTFILES/.config/alacritty/macos.toml $DOTFILES/.config/alacritty/os.toml
