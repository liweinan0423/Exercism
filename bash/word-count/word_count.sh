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

        count=${stats[$word]}
        stats[$word]=$((count + 1))
    fi
done

for word in "${!stats[@]}"; do
    echo "${word/-/\'}: ${stats["$word"]}"
done
