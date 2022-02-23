#!/usr/bin/env bash

to_decimal() {
    local digits=${1//\ /} base=$2
    local -i result
    while [[ $digits =~ ^0*1(.*)$ ]]; do
        offset=${#BASH_REMATCH[1]}
        ((result += (base ** offset)))
        digits=${BASH_REMATCH[1]}
    done

    local -a digits
    for ((i = 0; i < ${#result}; i++)); do
        digits+=("${result:i:1}")
    done

    echo "${digits[*]}"
}

decimal_to_base() {
    local decimal=${1//\ /} base=$2
    local -a digits
    local -i quotient=$decimal
    until ((quotient == base - 1)); do
        digits=($((quotient % base)) "${digits[@]}")
        ((quotient /= base))
    done
    digits=("$quotient" "${digits[@]}")
    echo "${digits[@]}"
}

convert() {
    local ibase=$1 digits=$2 obase=$3

    case $ibase-$obase in
    2-10)
        to_decimal "$2" 2
        ;;
    10-2)
        decimal_to_base "$2" 2
        ;;
    esac
}

main() {
    convert "$@"
}

main "$@"
