#!/bin/sh

echo "Install Alacritty"

CONFIG_DIR="$HOME/.config/alacritty"

mkdir -p "$CONFIG_DIR"

# Install themes repo
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

rm $CONFIG_DIR/alacritty.toml
ln -s $(pwd)/alacritty/alacritty.toml $CONFIG_DIR/alacritty.toml

