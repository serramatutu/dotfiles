#!/bin/bash

# We assume asdf was installed in the OS-bootstrap (Homebrew or apt)

echo "Running asdf-vm bootstrap"

cat "$DOTFILES/packages/asdf/plugins.txt" | xargs -I {} asdf plugin add "{}"

# In versions.txt, we keep a list of all installed versions of all packages
cat "$DOTFILES/packages/asdf/versions.txt" | tr "\n" "\0" | xargs -0 -L1 bash -c 'asdf install $0 $1'
# In .tool-versions, we keep the global versions we wish to use across the system
cat "$DOTFILES/home/.tool-versions" | tr "\n" "\0" | xargs -0 -L1 bash -c 'asdf install $0 $1'

asdf list
