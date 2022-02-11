#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

declare -i x y # coordinates
declare dir    # direction

process() {
    case $1 in
    R) turn_right ;;
    L) turn_left ;;
    A) advance ;;
    *) unknown ;;
    esac
}

unknown() {
    die "invalid instruction"
}
main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}
    local instructions=$4

    valid_direction "$dir" || die "invalid direction"

    while read -rn1 instruction; do
        process "$instruction"
    done < <(printf "%s" "$instructions")
    echo "$x $y $dir"
}

valid_direction() {
    [[ $1 == @(north|east|south|west) ]]
}

valid_instruction() {
    [[ $1 == [RAL] ]]
}

turn_left() {
    case $dir in
    north)
        dir=west
        ;;
    east)
        dir=north
        ;;
    south)
        dir=east
        ;;
    west)
        dir=south
        ;;
    esac
}

turn_right() {
    case $dir in
    north)
        dir=east
        ;;
    east)
        dir=south
        ;;
    south)
        dir=west
        ;;
    west)
        dir=north
        ;;
    esac
}

advance() {
    case $dir in
    north)
        y+=1
        ;;
    east)
        x+=1
        ;;
    south)
        y+=-1
        ;;
    west)
        x+=-1
        ;;
    esac
}

main "$@"
