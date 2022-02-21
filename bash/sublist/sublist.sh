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
    local -n __left=$1 __right=$2
    local left=${__left[*]} right=${__right[*]}

    if [[ $left == *$right* && $right == *$left* ]]; then
        echo equal
    elif [[ $left == *$right* && ! $right == *$left* ]] && ((${#__left[@]} > ${#__right[@]})); then
        echo superlist
    elif [[ ! $left == *$right* && $right == *$left* ]] && ((${#__left[@]} < ${#__right[@]})); then
        echo sublist
    else
        echo unequal
    fi
}

main "$@"
