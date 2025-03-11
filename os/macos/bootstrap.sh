#!/bin/bash

echo "Running MacOS bootstrap"

. "$DOTFILES/packages/homebrew/bootstrap.sh"

skhd --install-service
skhd --start-service

yabai --install-service
yabai --start-service

defaults write -g InitialKeyRepeat -int 13
defaults write -g KeyRepeat -int 2
defaults write com.apple.dock autohide-delay -float 0 
defaults write com.apple.dock autohide-time-modifier -float 0.5

ln -s $DOTFILES/.config/alacritty/macos.toml $DOTFILES/.config/alacritty/os.toml
