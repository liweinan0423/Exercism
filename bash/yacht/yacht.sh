#!/usr/bin/env bash

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
    local -A schema
    parse schema "$@"
    [[ ${schema[category]} == "full_house" ]] && total "$@"
}

big_straight() {
    local -A schema
    parse schema "$@"
    [[ ${schema[category]} == big_straight ]] && echo 30
}

little_straight() {
    local -A schema
    parse schema "$@"
    [[ ${schema[category]} == little_straight ]] && echo 30
}

four_of_a_kind() {
    local -A schema
    parse schema "$@"
    [[ ${schema[category]} =~ (four_of_a_kind|yacht) ]] && echo $((schema[four] * 4))
}
yacht() {
    local -A schema
    parse schema "$@"
    [[ ${schema[category]} =~ yacht ]] && echo 50
}
choice() {
    total "$@"
}

zero() {
    echo 0
}

parse() {
    local -n __schema=$1
    shift

    local -a sorted
    local IFS=$'\n'
    mapfile -t sorted < <(sort -n <<<"$*")

    IFS=""
    if [[ ${sorted[*]} =~ ${sorted[0]}{5} ]]; then
        __schema["category"]=yacht
        __schema["four"]=${sorted[0]} # yacht is also a four_of_a_kind
    elif [[ ${sorted[*]} == 12345 ]]; then
        __schema["category"]=little_straight
    elif [[ ${sorted[*]} == 23456 ]]; then
        __schema["category"]=big_straight
    elif [[ ${sorted[*]} =~ (${sorted[0]}{3}${sorted[3]}{2}|${sorted[0]}{2}${sorted[2]}{3}) ]]; then
        __schema["category"]=full_house
    elif [[ ${sorted[*]} =~ ([${sorted[0]}|${sorted[1]}]){4} ]]; then
        __schema["four"]="${BASH_REMATCH[1]}"
        __schema["category"]=four_of_a_kind
    fi
}

main() {
    local category=$1
    shift

    ${category// /_} "$@" || zero
}
main "$@"
