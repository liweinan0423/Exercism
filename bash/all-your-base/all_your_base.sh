#!/usr/bin/env bash

to_decimal() {
    local digits=${1//\ /} base=$2
    local -i result
    while [[ -n $digits ]]; do
        order=$((${#digits} - 1))
        n=${digits:0:1}
        ((result += (n * (base ** order))))
        digits=${digits#?}
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
    until ((quotient < base)); do
        digits=($((quotient % base)) "${digits[@]}")
        ((quotient /= base))
    done
    digits=("$quotient" "${digits[@]}")
    echo "${digits[@]}"
}

convert() {
    local ibase=$1 digits=$2 obase=$3

    case $ibase-$obase in
    3-16)
        digits=$(to_decimal "$digits" 3)
        decimal_to_base "$digits" 16
        ;;
    16-3)
        digits=$(to_decimal "$digits" 16)
        decimal_to_base "$digits" 3
        ;;
    2-10)
        to_decimal "$digits" 2
        ;;
    10-2)
        decimal_to_base "$digits" 2
        ;;
    esac
}

main() {
    convert "$@"
}

main "$@"
