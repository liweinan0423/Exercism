#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

main() {
    # arithmetic is delegated to `bc`
    [[ -x $(command -v bc) ]] || die "external tool required: bc"
    local cmd=$1
    shift
    "$cmd" "$@"
}

calculate() {
    bc <<<"$1"
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
    calculate "$g^$private%$p"
}

secret() {
    local -i p=$1 public=$2 private=$3

    calculate "$public^$private%$p"
}

main "$@"
