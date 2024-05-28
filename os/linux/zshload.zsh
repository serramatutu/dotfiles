source "$HOME/.asdf/asdf.sh"

shutdown() {
    command shutdown -h now
}

display_off() {
  xrandr --output eDP-1 --off --output HDMI-1 --auto
}

display_on() {
  xrandr --output eDP-1 --auto --output HDMI-1 --auto
}
