source "$HOME/.asdf/asdf.sh"

display_mobile() {
  xrandr --output eDP1 --below HDMI1 --auto
}

display_docked() {
  xrandr \
    --output eDP1 --below HDMI1 --auto \
    --output HDMI1 --primary --mode 2560x1440 --rate 60 
}
