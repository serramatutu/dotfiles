#!/bin/bash

echo "Running Linux bootstrap"

git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0

sh packages/apt/bootstrap.sh

ln -s $DOTFILES/.config/alacritty/linux.toml $DOTFILES/.config/alacritty/os.toml

# enable systemd services
systemctl --user enable ssh-agent
systemctl --user start ssh-agent
