#!/bin/sh
"$@"
(. ~/.zshrc)
clear
sleep 2
killall compton
neofetch --ascii_distro arch  --scrot_cmd 'scrot -z -u -d 0 /tmp/lock.png' -s & cat /home/joseph/.cache/wal/sequences & sleep 1.7; kill $!
compton -b & sleep .3
