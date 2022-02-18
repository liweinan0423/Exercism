#!/usr/bin/env bash

declare -A counters

declare -l char
while IFS= read -rn1 char; do
    if [[ -z ${counters[${char}]} ]]; then
        counters[$char]=1
    elif [[ $char != [\ -] ]]; then
        echo false
        exit
    fi
done < <(printf "%s" "$1")

echo true
