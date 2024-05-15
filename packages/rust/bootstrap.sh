#!/bin/sh

echo "Running Rust bootstrap"
if ! command -v cargo --version &> /dev/null
then
  echo "Installing Rust"
  curl --proto "=https" --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "Skipping Rust installation"
fi

cat "$DOTFILES/packages/rust/crates.txt" | xargs cargo install 
