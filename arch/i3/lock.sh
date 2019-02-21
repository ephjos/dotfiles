#!/bin/bash

scrot /tmp/screen.png


convert /tmp/lock.png -crop 600x345+0+0 /tmp/lock.png

ICON=/tmp/lock.png
TMPBG=/tmp/screen.png

# blurs it and overlays
convert $TMPBG -blur 0x10 $TMPBG
convert $TMPBG $ICON -gravity center -composite -matte $TMPBG

i3lock -e -u -i /tmp/screen.png -t -n

