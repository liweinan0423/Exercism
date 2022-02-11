#!/usr/bin/env bash

declare -ra Directions=(north east south west)
declare north=0 east=1 south=2 west=3

declare -i x y # coordinates
declare dir    # direction

main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}

    local instruction=$4

    process "$instruction"
    echo "$x $y $dir"
}

process() {

    local instruction=$1

    local idx
    case $instruction in
    R)
        idx=$((${!dir} + 1))
        idx=$((idx == 4 ? 0 : idx))
        dir=${Directions[idx]}
        ;;
    L)
        idx=$((${!dir} - 1))
        idx=$((idx < 0 ? 3 : idx))
        dir=${Directions[idx]}
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
