#!/usr/bin/env bash

#shellcheck disable=SC2086,SC2046,SC2068

triangle() {
    set -- $(normalize $1) $(normalize $2) $(normalize $3)
    sides_should_be_positive $@ &&
        sides_should_form_triangle $@ &&
        determine_type $@ || echo none
}

sides_should_be_positive() {
    (($1 > 0 && $2 > 0 && $3 > 0))
}

sides_should_form_triangle() {
    (($1 + $2 > $3 && $2 + $3 > $1 && $1 + $3 > $2))
}

determine_type() {
    local -i equals=0

    (($1 == $2)) && ((equals++))
    (($2 == $3)) && ((equals++))
    (($1 == $3)) && ((equals++))

    case $equals in
    2 | 3) echo equilateral ;;
    1) echo isosceles ;;
    0) echo scalene ;;
    esac
}
normalize() {
    echo $((${1/./} * 10))
}

main() {
    local expected=$1
    shift
    local actual
    actual=$(triangle $1 $2 $3)

    # this call goes to `command_not_found_handle` to imitate "dynamic meta-programming"
    if "${actual}_is_a" $expected; then
        echo true
    else
        echo false
    fi
}

command_not_found_handle() {
    if [[ $1 == *_is_a ]]; then
        local actual=${1%_is_a} expected=$2
        case $expected in
        isosceles)
            [[ $actual == @(isosceles|equilateral) ]]
            ;;
        *)
            [[ $actual == "$expected" ]]
            ;;
        esac
    else
        echo "${0##*/}: line ${BASH_LINENO[0]}: $1: command not found"
        exit 1
    fi
}

main "$@"
