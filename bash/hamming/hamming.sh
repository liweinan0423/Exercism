#!/usr/bin/env bash

error() {
    printf '%s\n' "$*"
    exit 1
}

(($# == 2)) || error "Usage: $0 <string1> <string2>"

left=$1 right=$2

((${#left} == ${#right})) || error "strands must be of equal length"

declare -i distance=0
for ((i = 0; i < ${#1}; i++)); do
    [[ "${left:i:1}" != "${right:i:1}" ]] && ((distance += 1))
done

printf '%d\n' "$distance"
