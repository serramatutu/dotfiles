#!/bin/sh

echo "Running Golang bootstrap"

if [[ "$OSTYPE" == "darwin"* ]]; then
  if ! command -v go version &> /dev/null
  then
    echo "Something went wrong. Go was not previously installed by Brew."
    exit 1
  fi
fi

cat "$DOTFILES/packages/go/packages.txt" | xargs go install

