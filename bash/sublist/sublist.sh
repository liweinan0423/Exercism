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
    local s1=${left[*]} s2=${right[*]}

    if [[ $s1 =~ .*\ ?$s2\ ?.* && $s2 =~ .*\ ?$s1\ ?.* ]]; then
        echo equal
    elif [[ $s1 =~ .*\ ?$s2\ ?.* && ! $s2 =~ .*\ ?$s1\ ?.* ]] && ((${#left[@]} > ${#right[@]})); then
        echo superlist
    elif [[ ! $s1 =~ .*\ ?$s2\ ?.* && $s2 =~ .*\ ?$s1\ ?.* ]] && ((${#left[@]} < ${#right[@]})); then
        echo sublist
    else
        echo unequal
    fi
}

main "$@"
