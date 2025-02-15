source "$HOME/.asdf/asdf.sh"

shutdown() {
    command shutdown --halt now
}

display_off() {
  xrandr --output eDP1 --off --output HDMI1 --auto --mode 2560x1440 --rate 60
}

display_on() {
  xrandr --output eDP1 --auto --output HDMI1 --auto
}
