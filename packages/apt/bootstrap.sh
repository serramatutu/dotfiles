#!/bin/bash

echo "Running apt bootstrap"

cat $DOTFILES/packages/apt/repositories.txt | xargs sudo add-apt-repository -y
sudo apt update
cat $DOTFILES/packages/apt/packages.txt | xargs sudo apt install -y

# For Git LFS
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
