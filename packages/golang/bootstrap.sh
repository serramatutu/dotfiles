#!/bin/sh

echo "Running Golang bootstrap"

cat "$DOTFILES/packages/golang/packages.txt" | xargs -I {} go install "{}"

asdf reshim golang
