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

    esac

}

is_yacht() {
    (($1 == $2 && $1 == $3 && $1 == $4 && $1 == $5))
}

yacht() {
    echo 50
}

ones() {
    local -i score
    for roll; do
        ((roll == 1)) && ((score++))
    done

    echo "$score"
}

zero() {
    echo 0
}

main "$@"
