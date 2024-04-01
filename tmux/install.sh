#!/bin/sh

rm -f -- $HOME/.tmux.conf
ln -s $(pwd)/tmux/.tmux.conf $HOME/.tmux.conf
