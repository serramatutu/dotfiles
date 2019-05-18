# dotfiles

This repo contains the dotfiles for installing [serramatutu](https://github.com/serramatutu)'s system (Ubuntu) dependencies.

## installing
To install the dotfiles, simply run
```
git clone https://github.com/serramatutu/dotfiles ~/.dotfiles

cd ~/.dotfiles

sudo sh installer/bootstrap
```

## components
The dotfiles repo is subdivided into topics, which are all modular and self-contained. Some of the files contained in topics will be treated specially:
- **topic/\*.zsh**: a zshell file containing aliases, environment variables or any other shell environment configurations. All of those configurations will be loaded onto the _zsh_ environment.
- **topic/\*.symlink**: a file of any type which will be symlinked from the _.dotfiles_ repo onto the _home_ directory. This allows for versioning through this repository while retaining the files functional.
- **topic/install.py**: a python3 module which contains at least an ```install()``` function. This function may prompt the user for custom input, run shell scripts or do virtually anything else.

## todo
- Snap installs (vscode, firefox)
- Multiple ssh-keys, as shown [here](https://gist.github.com/jexchan/2351996/) (autosetup with prompts).

## disclaimer
This project was heavily inspired by [holman's dotfiles](https://github.com/holman/dotfiles).