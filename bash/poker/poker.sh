#!/usr/bin/env bash

source ./utils_poker.sh

main() {
    local -a winners=("$1")
    shift
    for hand; do
        case $(compare "$hand" "${winners[0]}") in
        win)
            winners=("$hand")
            ;;
        tie)
            winners+=("$hand")
            ;;
        esac
    done
    local IFS=$'\n'
    echo "${winners[*]}"
}

declare -rA Priorities=(
    [straight_flush]=1
    [four_of_a_kind]=2
    [full_house]=3
    [flush]=4
    [straight]=5
    [three_of_a_kind]=6
    [two_pairs]=7
    [one_pair]=8
    [high_card]=9
)
compare() {
    local -a hand1 hand2
    local category1 category2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"
    category1=${hand1[0]}
    category2=${hand2[0]}
    if ((${Priorities[$category1]} < ${Priorities[$category2]})); then
        echo win
    elif ((${Priorities[$category1]} > ${Priorities[$category2]})); then
        echo loose
    else
        "compare_in_category" "$1" "$2"
    fi
}

compare_in_category() {
    local -a hand1 hand2 ranks1 ranks2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"

    ranks1=("${hand1[@]:1}")
    ranks2=("${hand2[@]:1}")
    array::remove ranks1 "[SHDC]"
    array::remove ranks2 "[SHDC]"

    ranks::compare "${ranks1[*]}" "${ranks2[*]}"
}

main "$@"
