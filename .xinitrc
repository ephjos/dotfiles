#!/bin/sh

# xinitrc runs automatically when you run startx.

# If the file exists, run .config/.screens
# Allows device specific window layout config through xrandr
[[ -f "$HOME/.config/.screens" ]] && bash "$HOME/.config/.screens"

. ~/.xprofile # Source xprofile
startdwm
