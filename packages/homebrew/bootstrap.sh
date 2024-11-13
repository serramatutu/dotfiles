#!/bin/bash

if ! command -v brew --version &> /dev/null
then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Skipping Homebrew installation"
fi

brew bundle install

