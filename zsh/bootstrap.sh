#!/bin/sh

echo "Running ZSH bootstrap"

if ! command -v omz version &> /dev/null
then
  echo "Installing Oh My ZSH"
  curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh | /bin/sh
else
  echo "Skipping Oh My ZSH installation"
fi

ZSH="$HOME/.oh-my-zsh"

scripts/ln_contents "zsh/themes" "$ZSH/themes"
scripts/ln_contents "zsh/plugins" "$ZSH/plugins"


if [ ! -e $HOME/.zshenv ]; then
    echo "Creating .zshenv"
    touch $HOME/.zshenv
else
  echo "Skipping .zshenv creation"
fi
