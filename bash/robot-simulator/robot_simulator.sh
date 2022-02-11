#!/usr/bin/env bash

main() {
    local -i x=${1:-0} y=${2:-0}
    local dir=${3:-north}

    echo "$x $y $dir"
}

main "$@"
