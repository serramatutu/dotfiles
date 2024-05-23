#!/bin/sh

echo "Initializing submodules"
git submodule update --init --recursive > /dev/null

export DOTFILES="$HOME/.dotfiles"

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  . "$DOTFILES/os/linux/bootstrap.sh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  . "$DOTFILES/os/macos/bootstrap.sh"
fi

. zsh/bootstrap.sh

. packages/asdf/bootstrap.sh
. packages/rust/bootstrap.sh
. packages/golang/bootstrap.sh
. packages/python/bootstrap.sh

scripts/ln_home
scripts/ln_config
