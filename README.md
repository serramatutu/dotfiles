# dotfiles

This repo contains the dotfiles for installing [serramatutu](https://github.com/serramatutu)'s system (Ubuntu) dependencies.

## installing
To install the dotfiles, simply run
```
git clone https://github.com/serramatutu/dotfiles ~/.dotfiles

cd ~/.dotfiles

sudo sh installer/bootstrap
```

## testing
In order to test the dotfiles project, please run
```
sh test/bootstrap
```

If you need to inspect the installation results, please run
```
sh test/bootstrap --inspect
sh test/inspect
```

Note that you must have [docker](https://www.docker.com/) installed on your machine so that the installation test does not affect your computer (otherwise you would end up having to clean a whole mess every time the project is tested :p).

## components
The dotfiles repo is subdivided into topics, which are all modular and self-contained. Some of the files contained in topics will be treated specially:
- **topics/topic/\*.zsh**: a zshell file containing aliases, environment variables or any other shell environment configurations. All of those configurations will be loaded onto the _zsh_ environment.
- **topics/topic/\*.symlink**: a file of any type which will be symlinked from the _.dotfiles_ repo onto the _home_ directory. This allows for versioning through this repository while retaining the files functional.
- **topics/topic/install.py**: a python3 module which contains at least an ```install()``` function. This function may prompt the user for custom input, run shell scripts or do virtually anything else. It may also contain ```provides()``` and ```requires()``` methods that return iterables of the install's requirements and fulfillments. This is used to determine the installation order. _Note: a topic's ```provides()``` method implicitly returns the topic itself_

## todo
- Snap installs (vscode, firefox)
- Multiple ssh-keys, as shown [here](https://gist.github.com/jexchan/2351996/) (autosetup with prompts).
- Flag for abort when file exists

## disclaimer
This project was heavily inspired by [holman's dotfiles](https://github.com/holman/dotfiles).