#!/bin/bash

export PATH=$PATH:/home/joseph/.scripts

sp current &> /dev/null

if [[ "$?" = 1 ]]; then
	echo " nothing... "
	exit 0
fi

artist=$(sp current | awk '$1=="Artist"{$1=""; print $0}')
title=$(sp current | awk '$1=="Title"{$1=""; print $0}')

echo "$artist -$title "

