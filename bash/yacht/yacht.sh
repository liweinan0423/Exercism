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
    [[ $(parse schema "$@") == "full_house" ]] && total "$@"
}

big_straight() {
    local -A schema
    parse schema "$@" >/dev/null
    [[ ${schema[category]} == big_straight ]] && echo 30
}

little_straight() {
    local -A schema
    parse schema "$@" >/dev/null
    [[ ${schema[category]} == little_straight ]] && echo 30
}

four_of_a_kind() {
    local -A schema
    parse schema "$@" >/dev/null
    [[ ${schema[category]} =~ (four_of_a_kind|yacht) ]] && echo $((schema[four] * 4))
}
yacht() {
    local category
    category=$(parse schema "$@")
    [[ $category == yacht ]] && echo 50
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

    local category
    IFS=""
    if [[ ${sorted[*]} =~ ${sorted[0]}{5} ]]; then
        category=yacht
        __schema["category"]=yacht
        __schema["four"]=${sorted[0]} # yacht is also a four_of_a_kind
    elif [[ ${sorted[*]} == 12345 ]]; then
        category=little_straght
        __schema["category"]=little_straight
    elif [[ ${sorted[*]} == 23456 ]]; then
        category=big_straight
        __schema["category"]=big_straight
    elif [[ ${sorted[*]} =~ (${sorted[0]}{3}${sorted[3]}{2}|${sorted[0]}{2}${sorted[2]}{3}) ]]; then
        category=full_house
        __schema["category"]=full_house
    elif [[ ${sorted[*]} =~ ([${sorted[0]}|${sorted[1]}]){4} ]]; then
        category=four_of_a_kind
        __schema["four"]="${BASH_REMATCH[1]}"
        __schema["category"]=four_of_a_kind
    fi
    echo "$category"
}

main() {
    local category=$1
    shift

    ${category// /_} "$@" || zero
}
main "$@"
