#!/usr/bin/env bash

main() {
    local square=$1
    case $square in
    [1-9] | [1-5][0-9] | 6[0-4]) # match numbers from 1 to 64
        printf "%u\n" "$(number_of_square "$square")"
        ;;
    total)
        local -i total
        for i in {1..64}; do
            total+=$(number_of_square "$i")
        done
        printf "%u\n" "$total"
        ;;
    *)
        die "Error: invalid input"
        ;;
    esac
}

number_of_square() {
    printf "%u" $((2 ** ($* - 1)))
}

die() {
    echo "$@" >&2
    exit 1
}
main "$@"
