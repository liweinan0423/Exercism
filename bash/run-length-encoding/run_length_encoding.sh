#!/usr/bin/env bash

main() {
    case $1 in
    encode | decode)
        $1 "$2"
        ;;
    *)
        echo "usage: $0 <encode|decode> arg"
        ;;
    esac
}

encode() {
    local count next char
    while IFS= read -rn1 next; do
        if [[ $next == "$char" ]]; then
            ((count++))
        else
            render "$count" "$char"
            count=1
            char=$next
        fi
    done < <(printf "%s" "$1")

    render "$count" "$char"
}

decode() {
    local encoded=$1
    local count char self
    while [[ $encoded =~ ([0-9]*)([a-zA-Z ]) ]]; do
        self=${BASH_REMATCH[0]}
        count=${BASH_REMATCH[1]}
        char=${BASH_REMATCH[2]}
        repeat "$count" "$char"
        encoded=${encoded##"${self}"}
    done
}

repeat() {
    local count=$1 char=$2
    [[ -n $count ]] || count=1
    for ((i = 0; i < count; i++)); do
        echo -n "$char"
    done
}

render() {
    local count=$1 char=$2
    ((count == 1)) && count=
    echo -n "$count$char"
}

main "$@"
