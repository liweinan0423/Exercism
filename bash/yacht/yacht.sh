#!/usr/bin/env bash

# shellcheck disable=SC2015

main() {
    local category=$1

    shift
    case $category in
    yacht)
        is_yacht "$@" && yacht || zero
        ;;
    ones)
        ones "$@"
        ;;
    twos)
        twos "$@"
        ;;
    esac

}

is_yacht() {
    (($1 == $2 && $1 == $3 && $1 == $4 && $1 == $5))
}

yacht() {
    echo 50
}

ones() {
    local -i score=0
    for roll; do
        ((roll == 1)) && ((score += 1))
    done

    echo "$score"
}

twos() {
    local -i score=0
    for roll; do
        ((roll == 2)) && ((score += 2))
    done

    echo "$score"
}

zero() {
    echo 0
}

main "$@"
