#!/usr/bin/env bash

# shellcheck disable=SC2015

main() {
    local category=$1

    shift
    case $category in
    yacht)
        is_yacht "$@" && yacht || zero
        ;;
    ones | twos | threes | fours | fives | sixes)
        $category "$@"
        ;;

    "full house")
        is_fullhouse "$@" && total "$@" || zero
        ;;
    "four of a kind")
        is_four_of_a_kind "$@" && four_of_a_kind "$@" || zero
        ;;
    esac
}

is_yacht() {
    is_combination 5 "$@"
}
is_combination() {
    local pattern=$1
    shift
    local -A counter
    for roll; do
        counter[$roll]=$((counter[$roll] + 1))
    done
    [[ ${counter[*]} =~ $pattern ]]
}
is_fullhouse() {
    is_combination "(2 3|3 2)" "$@"
}

is_four_of_a_kind() {
    is_combination "(1 4|4 1)" "$@" || is_yacht "$@"
}

four_of_a_kind() {

    local -A counter
    for roll; do
        counter[$roll]=$((counter[$roll] + 1))
    done
    [[ ${counter[*]} =~ (1 4|4 1|5) ]] || return 1

    for roll in "${!counter[@]}"; do
        ((counter[$roll] >= 4)) && echo $((4 * roll)) && return
    done
}

yacht() {
    echo 50
}

total() {
    local -i score=0
    for roll; do
        ((score += roll))
    done
    echo "$score"
}

numbers() {
    local -i number=$1 score=0
    shift
    for roll; do
        ((roll == number)) && ((score += number))
    done
    echo "$score"
}

ones() {
    numbers 1 "$@"
}

twos() {
    numbers 2 "$@"
}
threes() {
    numbers 3 "$@"
}
fours() {
    numbers 4 "$@"
}
fives() {
    numbers 5 "$@"
}
sixes() {
    numbers 6 "$@"
}

zero() {
    echo 0
}

main "$@"
