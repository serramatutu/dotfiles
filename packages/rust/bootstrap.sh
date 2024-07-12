#!/bin/bash

echo "Running Rust bootstrap"

cat "$DOTFILES/packages/rust/crates.txt" | xargs -I {} cargo install "{}"

# rust-analyzer is weird to install and takes a long time to compile
if [ ! command -v rust-analyzer --version &> /dev/null ] || [ "$FORCE_RUST_ANALYZER" == "1" ]; then
  local curr_pwd=$(pwd)
  git clone https://github.com/rust-lang/rust-analyzer.git /tmp/rust-analyzer
  cd /tmp/rust-analyzer
  cargo xtask install --server
  cd $curr_pwd
  rm -rf /tmp/rust-analyzer
else
  echo "Skipping rust-analyzer installation since that takes a long time. User FORCE_RUST_ANALYZER=1 to override."
fi

rustup component add clippy
rustup component add rustfmt
