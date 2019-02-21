#!/bin/sh

#sensors | grep Core | awk '{print substr($3, 2, length($3)-5)}' | tr "\\n" " " | sed 's/ /°C  /g' | sed 's/  $//'

sensors | awk 'NR>8 && $1 == "temp1:" {print $2}' | tr -d +
