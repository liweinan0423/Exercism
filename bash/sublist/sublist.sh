#!/usr/bin/env bash

main() {
    local -a a b
    parse a "$1"
    parse b "$2"

    if is_sublist a b && is_sublist b a; then
        echo equal
    elif is_sublist a b && ! is_sublist b a; then
        echo sublist
    elif ! is_sublist a b && is_sublist b a; then
        echo superlist
    else
        echo unequal
    fi
}

parse() {
    local -n __array=$1
    local IFS
    IFS=, read -ra __array <<<"${2//[\[\]]/}"
}

is_sublist() {
    local -n __left=$1 __right=$2

    local sublist=true

    local -i pL=0 pR=0 start=0
    while ((pL < ${#__left[@]} && pR < ${#__right[@]})); do
        if [[ ${__left[pL]} -eq ${__right[pR]} ]]; then
            sublist=true
            ((pL++))
            ((pR++))
        else
            sublist=false
            pL=0
            ((start++))
            pR=$start
        fi
    done

    if ((pL != ${#__left[@]})); then
        sublist=false
    fi

    $sublist
}

main "$@"
