#!/bin/sh

echo "Running Rust bootstrap"

cat "$DOTFILES/packages/rust/crates.txt" | xargs -I {} cargo install "{}"
asdf reshim rust
