#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}
declare -i x y # coordinates
declare dir    # direction
main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}
    local instructions=$4

    valid_direction "$dir" || die "invalid direction: $dir"

    while read -rn1 instruction; do
        process "$instruction"
    done < <(printf "%s" "$instructions")
    echo "$x $y $dir"
}

valid_direction() {
    [[ -n ${turnLeft[$1]} ]]
}

process() {
    case $1 in
    R) turn_right ;;
    L) turn_left ;;
    A) advance ;;
    *) unknown "$1" ;;
    esac
}

declare -A turnLeft=([north]=west [east]=north [south]=east [west]=south)
declare -A turnRight=([north]=east [east]=south [south]=west [west]=north)
declare -A dx=([north]=0 [south]=0 [east]=1 [west]=-1)
declare -A dy=([north]=1 [south]=-1 [east]=0 [west]=0)


turn_left() {
    dir=${turnLeft[$dir]}
}

turn_right() {
    dir=${turnRight[$dir]}
}

advance() {
    x+=${dx[$dir]}
    y+=${dy[$dir]}
}

unknown() {
    die "invalid instruction: $1"
}
main "$@"
