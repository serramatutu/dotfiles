#!/bin/sh

echo "Running Python bootstrap"

echo "Installing pyenv"
curl --proto "=https" --tlsv1.2 -sSf https://pyenv.run | bash

pyenv install 3.12
pyenv global 3.12

python -m pip install --quiet -U pip
python -m pip install --quiet -r "$DOTFILES/packages/python/requirements.txt"

