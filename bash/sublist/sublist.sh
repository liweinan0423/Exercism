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
    local s1=${__left[*]} s2=${__right[*]}

    if [[ $s1 == *$s2* && $s2 == *$s1* ]]; then
        echo equal
    elif [[ $s1 == *$s2* && ! $s2 == *$s1* ]] && ((${#__left[@]} > ${#__right[@]})); then
        echo superlist
    elif [[ ! $s1 == *$s2* && $s2 == *$s1* ]] && ((${#__left[@]} < ${#__right[@]})); then
        echo sublist
    else
        echo unequal
    fi
}

main "$@"
