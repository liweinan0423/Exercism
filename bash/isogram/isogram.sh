#!/usr/bin/env bash

declare -A counters

declare -l char
while IFS= read -rn1 char; do
    [[ $char != [\ -] ]] && ((counters[$char]++))
done < <(printf "%s" "$1")

[[ $(printf "%s" "${counters[@]}") =~ ^1*$ ]] && echo true || echo false