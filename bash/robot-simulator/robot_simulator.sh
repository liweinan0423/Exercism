#!/usr/bin/env bash

main() {
    local -i x=$1 y=$2
    local dir=$3

    echo "$x $y $dir"
}

main "$@"
