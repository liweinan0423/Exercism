#!/usr/bin/env bash

shopt -s extglob

phrase=$1
phrase=${phrase,,}        # lower case all letters
phrase=${phrase//"\n"/\ } # replace literal "\n" with space
phrase=${phrase//[,*]/\ } # replace all delimeters with space

declare -A stats
for word in $phrase; do
    if [[ -n $word ]]; then
        word=${word#\'}            # remote leading single quote
        word=${word%\'}            # remove trailing single quote
        word=${word//[^a-z0-9\']/} # remove special characters
        word=${word/\'/-}          # associative array doesn't like "'" in the key, replace with "-" temporarily
        ((stats[$word]++))
    fi
done

for word in "${!stats[@]}"; do
    echo "${word/-/\'}: ${stats["$word"]}"
done
