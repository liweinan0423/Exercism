#!/usr/bin/env bash

# shellcheck disable=SC2015

main() {
    local category=$1

    shift
    case $category in
    yacht)
        is_yacht "$@" && yacht || zero
        ;;
    ones | twos | threes | fours)
        $category "$@"
        ;;
    esac

}

is_yacht() {
    (($1 == $2 && $1 == $3 && $1 == $4 && $1 == $5))
}

yacht() {
    echo 50
}

numbers() {
    local -i number=$1 score=0
    shift
    for roll; do
        ((roll == number)) && ((score += number))
    done
    echo "$score"
}

ones() {
    numbers 1 "$@"
}

twos() {
    numbers 2 "$@"
}
threes() {
    numbers 3 "$@"
}
fours() {
    numbers 4 "$@"
}

zero() {
    echo 0
}

main "$@"
