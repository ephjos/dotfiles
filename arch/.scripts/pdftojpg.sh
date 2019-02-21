#!/bin/bash
#

if (( "$#" == 1 )) ; then
		convert -quality 100 -density 600x600 "$1".pdf "$1"%d.jpg
    exit 0
fi

echo "Invalid arguments" >&2
exit 1
