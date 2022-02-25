#!/usr/bin/env bash

main() {
    "$1" "$2"
}

privateKey() {
    local -i p=$1 r=0
    while ! prime "$r" || ((r >= p)); do
        r=$((RANDOM % p + 1))
    done

    echo $r
}

prime() {
    local -i n=$1 i
    ((n < 2)) && return 1
    ((n == 2)) && return 0
    for ((i = 2; i < n; i++)); do
        if ((n % i == 0)); then
            return 1
        fi
    done

    return 0
}

main "$@"
