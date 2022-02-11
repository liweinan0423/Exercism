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
    case $dir,$instruction in
    north,R) dir=east ;;
    south,L) dir=east ;;
    north,L) dir=west ;;
    south,R) dir=west ;;
    east,R) dir=south ;;
    west,L) dir=south ;;
    east,L) dir=north ;;
    west,R) dir=north ;;
    east,A) ((x++)) ;;
    west,A) ((x--)) ;;
    north,A) ((y++)) ;;
    south,A) ((y--)) ;;
    esac
}

main "$@"
