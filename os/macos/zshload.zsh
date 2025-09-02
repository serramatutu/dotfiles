# Fix locale issue
# See: https://apple.stackexchange.com/questions/451014/unknown-locale-assuming-c-error-message-in-terminal
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

# Homebrew Intel/ARM
export HOMEBREW_BUNDLE_FILE="$DOTFILES/packages/homebrew/Brewfile"
alias ibrew="arch -x86_64 /usr/local/bin/brew"

# default container arch for act since running on M1
act() {
  command act --container-architecture=linux/amd64 $@
}

# run as intel
i() {
  PATH="$(ibrew --prefix)/bin:$PATH" arch -x86_64 "$@"
}

# Quickly change sleep settings (allows using it with lid closed)
dontsleep() { 
  echo "Disabling sleep"
  sudo pmset -a disablesleep 1
}

sleep() {
  echo "Enabling sleep"
  sudo pmset -a disablesleep 0
}
