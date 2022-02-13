#!/usr/bin/env bash

declare -a Groups
sum_of() {
    local -i number=$1 score=0
    shift
    for roll; do
        ((roll == number)) && ((score += number))
    done
    echo "$score"
}

total() {
    local -i score=0
    for roll; do
        ((score += roll))
    done
    echo "$score"
}

ones() {
    sum_of 1 "$@"
}

twos() {
    sum_of 2 "$@"
}
threes() {
    sum_of 3 "$@"
}
fours() {
    sum_of 4 "$@"
}
fives() {
    sum_of 5 "$@"
}
sixes() {
    sum_of 6 "$@"
}

full_house() {
    ((${#Groups[@]} == 2)) || return 1
    for die in "${!Groups[@]}"; do
        if [[ ${Groups[die]} == [23] ]]; then
            total "$@"
            return
        else
            return 1
        fi
    done
}

big_straight() {
    local -a sorted
    local IFS=$'\n'
    mapfile -t sorted < <(sort -n <<<"$*")
    unset IFS
    [[ ${sorted[*]} == "2 3 4 5 6" ]] && echo 30
}

little_straight() {
    local -a sorted
    local IFS=$'\n'
    mapfile -t sorted < <(sort -n <<<"$*")
    unset IFS
    [[ ${sorted[*]} == "1 2 3 4 5" ]] && echo 30
}

four_of_a_kind() {
    for die in "${!Groups[@]}"; do
        if [[ ${Groups[die]} == [45] ]]; then
            echo $((4 * die))
            return
        fi
    done
    return 1
}
yacht() {
    ((${#Groups[@]} == 1)) && echo 50
}
choice() {
    total "$@"
}

zero() {
    echo 0
}

parse() {
    for die; do
        ((Groups[die] += 1))
    done
}
main() {
    local category=$1
    shift
    parse "$@"
    ${category// /_} "$@" || zero
}
main "$@"
