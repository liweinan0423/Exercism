#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    "$cmd" "$@"
}

privateKey() {
    local -i p=$1 r

    while ((r < 2)); do
        r=$((RANDOM % p))
    done

    echo "$r"
}

publicKey() {
    local -i p=$1 g=$2 private=$3
    echo $(((g ** private) % p))
}

secret() {
    local -i p=$1 public=$2 private=$3

    echo $((public ** private % p))
}

main "$@"
