#!/bin/sh

echo "Install Oh My ZSH"

if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Install spaceship prompt
git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH/themes/spaceship-prompt" --depth=1
ln -s "$ZSH/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH/themes/spaceship.zsh-theme"

# Install vim movements
git clone https://github.com/jeffreytse/zsh-vi-mode "$ZSH/plugins/zsh-vi-mode" --depth=1

rm $HOME/.zshrc
ln -s $(pwd)/zsh/.zshrc $HOME/.zshrc

