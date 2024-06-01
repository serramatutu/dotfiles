#!/bin/bash

echo "Running Rust bootstrap"

cat "$DOTFILES/packages/rust/crates.txt" | xargs -I {} cargo install "{}"

# rust-analyzer is weird to install
curr_pwd=$(pwd)
git clone https://github.com/rust-lang/rust-analyzer.git /tmp/rust-analyzer
cd /tmp/rust-analyzer
cargo xtask install --server
cd $curr_pwd
rm -rf /tmp/rust-analyzer


asdf reshim rust
