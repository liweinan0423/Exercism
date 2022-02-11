#!/usr/bin/env bash

main() {
    local prev current
    local result
    local -i counter=1
    while read -rn1 current; do
        result+=$current
    done < <(printf "%s" "$2")

    echo "$result"
}

main "$@"
