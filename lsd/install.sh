#!/bin/sh

echo "Install lsd"

cargo install lsd

CONFIG_DIR="$HOME/.config/lsd"

mkdir -p "$CONFIG_DIR"

rm $CONFIG_DIR/config.yaml
ln -s $(pwd)/lsd/config.yaml $CONFIG_DIR/config.yaml

