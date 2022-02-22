#!/usr/bin/env bash
readonly -A Scores=(
    [eggs]=1
    [peanuts]=2
    [shellfish]=4
    [strawberries]=8
    [tomatoes]=16
    [chocolate]=32
    [pollen]=64
    [cats]=128
)

allergic_to() {
    local score=$1 allergy=$2
    ((${Scores[$allergy]} == score))
}

main() {
    if allergic_to "$1" "$3"; then
        echo true
    else
        echo false
    fi
}

main "$@"
