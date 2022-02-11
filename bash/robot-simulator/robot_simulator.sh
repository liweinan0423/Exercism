#!/usr/bin/env bash

declare -i x y # coordinates
declare dir    # direction

die() {
    echo "$1"
    exit 1
}

main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}
    [[ $dir == @(north|east|south|west) ]] || die "invalid direction"
    local instructions=$4

    while read -rn1 instruction; do
        [[ $instruction == [RAL] ]] || die "invalid instruction"
        process "$instruction"
    done < <(printf "%s" "$instructions")
    echo "$x $y $dir"
}

process() {
    local instruction=$1
    case $instruction in
    R)
        case $dir in
        north) dir=east ;;
        east) dir=south ;;
        south) dir=west ;;
        west) dir=north ;;
        esac
        ;;
    L)
        case $dir in
        north) dir=west ;;
        east) dir=north ;;
        south) dir=east ;;
        west) dir=south ;;
        esac
        ;;
    A)
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
        ;;
    esac
}

main "$@"
