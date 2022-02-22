#!/usr/bin/env bash

factors() {
    local -a factors
    for ((i = 1; i < $1; i++)); do
        if (($1 % i == 0)); then
            factors+=("$i")
        fi
    done

    echo "${factors[@]}"
}

perfect() {

    local -i product=1
    for i in $(factors "$1"); do
        ((product *= i))
    done

    ((product == $1))
}

main() {
    if perfect "$1"; then
        echo perfect
    fi
}

main "$@"
