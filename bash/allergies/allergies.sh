#!/usr/bin/env bash
readonly -a Allergens=(
    eggs
    peanuts
    shellfish
    strawberries
    tomatoes
    chocolate
    pollen
    cats
)

allergic_to() {
    local score=$1 allergy=$2

    if [[ $(allergies "$1") == *$allergy* ]]; then
        echo true
    else
        echo false
    fi
}

allergies() {
    local score=$1

    local -a allergies

    for ((i = 0; i < ${#Allergens[@]}; i++)); do
        if (((score & (1 << i)) != 0)); then
            allergies+=("${Allergens[i]}")
        fi
    done

    echo "${allergies[*]}"
}

main() {
    case $2 in
    allergic_to)
        allergic_to "$1" "$3"
        ;;
    list)
        allergies "$1"
        ;;
    esac
}

main "$@"
