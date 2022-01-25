#!/usr/bin/env bash

main() {
    local -i number=${1} length=${#1} sum=0 digit
    while read -r -n1 digit; do
        sum+=$((digit ** length))
    done <<<"$number"
    ((sum == number)) && echo "true" || echo "false"
}

main "$@"
