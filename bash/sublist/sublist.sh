#!/usr/bin/env bash


main() {
    local -a a b
    parse a "$1"
    parse b "$2"

    compare a b
}

parse() {
    local -n __array=$1
    local IFS
    IFS=, read -ra __array <<<"${2//[\[\][:space:]]/}"
}

compare() {
    local -n left=$1 right=$2
    if ((${#left[@]} == 0 && ${#right[@]} == 0)); then
        echo equal
    elif ((${#left[@]} == 0 && ${#right[@]} > 0)); then
        echo sublist
    elif ((${#left[@]} > 0 && ${#right[@]} == 0)); then
        echo superlist
    else
        :
    fi
}

main "$@"
