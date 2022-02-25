#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    "$cmd" "$@"
}

privateKey() {
    local -i p=$1 r=0
    until prime "$r" && ((r < p)); do
        r=$((RANDOM % p + 1))
    done

    echo $r
}

publicKey() {
    local -i p=$1 g=$2 private=$3

    echo $(((g ** private) % p))
}

secret() {
    local -i p=$1 public=$2 private=$3

    echo $((public ** private % p))
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
