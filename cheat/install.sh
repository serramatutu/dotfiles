#!/bin/sh

echo "Install cheat (requires Golang)"
if ! [ -x "$(command -v go --version)" ]; then
  echo "Skipping cheat installation. Go is unavailable."
else
  go install github.com/cheat/cheat/cmd/cheat@latest
fi

CONFIG_DIR="$HOME/.config/cheat"

ln -s "$(pwd)/cheat/config" "$CONFIG_DIR"
