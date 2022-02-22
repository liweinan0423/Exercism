#!/usr/bin/env bash
readonly -A Scores=(
    [1]=eggs
    [2]=peanuts
    [4]=shellfish
    [8]=strawberries
    [16]=tomatoes
    [32]=chocolate
    [64]=pollen
    [128]=cats
)

allergic_to() {
    local score=$1 allergy=$2

    [[ $(allergies "$1") == *$allergy* ]]
}

allergies() {
    local score=$1

    local bin=$(bc <<<"ibase=10;obase=2;$score")
    local -a allergies

    while [[ $bin =~ ^1(0*(.*)) ]]; do
        exp=${#BASH_REMATCH[1]}
        allergies+=("${Scores[$((2 ** exp))]}")
        bin=${BASH_REMATCH[2]}
    done

    echo "${allergies[*]}"
}

main() {
    if $2 "$1" "$3"; then
        echo true
    else
        echo false
    fi
}

main "$@"
