#!/bin/bash

echo "Running Python bootstrap"

python -m pip install --quiet -U pip
python -m pip install --quiet -r "$DOTFILES/packages/python/requirements.txt"

