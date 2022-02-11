#!/usr/bin/env bash

declare -ra Directions=(north east south west)
declare north=0 east=1 south=2 west=3

main() {
    local -i x=${1:-0} y=${2:-0}
    local dir=${3:-north}
    local instruction=$4

    case $instruction in
    R)
        idx=$((${!dir} + 1))
        idx=$((idx == 4 ? 0 : idx))
        dir=${Directions[$idx]}
        ;;
    L)
        idx=$((${!dir} - 1))
        idx=$((idx < 0 ? 3 : idx))
        dir=${Directions[$idx]}
        ;;
    esac

    echo "$x $y $dir"
}

main "$@"
