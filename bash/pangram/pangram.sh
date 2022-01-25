#!/usr/bin/env bash

main() {
    [[ -n $1 ]] || quit "false"
    local -A alphabets=()
    local char
    while read -r -n1 char; do
        char=${char,}
        case $char in
        [a-zA-Z])
            alphabets[${char}]=1
            ;;
        *)
            continue
            ;;
        esac
    done <<<"$1"

    ((${#alphabets[@]} == 26)) && echo "true" || echo "false"
}

quit() {
    echo "$1"
    exit 0
}

main "$@"
