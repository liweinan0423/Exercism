#!/usr/bin/env bash

declare -ra Directions=(north east south west)
declare north=0 east=1 south=2 west=3

declare -i x y # coordinates
declare dir    # direction

die() {
    echo "$1"
    exit 1
}

main() {
    x=${1:-0} y=${2:-0}
    dir=${3:-north}
    ((${!dir} < 4 && ${!dir} >= 0)) || die "invalid direction"
    local instructions=$4

    while read -rn1 instruction; do
        process "$instruction"
    done < <(printf "%s" "$instructions")
    echo "$x $y $dir"
}

process() {
    local instruction=$1
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
