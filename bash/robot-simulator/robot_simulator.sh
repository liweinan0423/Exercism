#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

declare -i x y # coordinates
declare dir    # direction

declare -A Instructions=(
    [R]=turn_right
    [L]=turn_left
    [A]=advance
)
main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}
    local instructions=$4

    valid_direction "$dir" || die "invalid direction"

    while read -rn1 instruction; do
        valid_instruction "$instruction" || die "invalid instruction"
        ${Instructions[$instruction]}
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
        ((y++))
        ;;
    east)
        ((x++))
        ;;
    south)
        ((y--))
        ;;
    west)
        ((x--))
        ;;
    esac
}

main "$@"
