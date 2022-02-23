#!/usr/bin/env bash

binary_to_decimal() {
    local bin=${1//\ /}
    local -i result
    while [[ $bin =~ ^0*1(.*)$ ]]; do
        offset=${#BASH_REMATCH[1]}
        ((result += (2 ** offset)))
        bin=${BASH_REMATCH[1]}
    done

    local -a digits
    for ((i = 0; i < ${#result}; i++)); do
        digits+=("${result:i:1}")
    done

    echo "${digits[*]}"
}

decimal_to_binary() {
    local decimal=${1//\ /}
    local -a bits
    local -i quotient=$decimal
    until ((quotient == 1)); do
        bits=($((quotient % 2)) "${bits[@]}")
        ((quotient /= 2))
    done
    bits=("$quotient" "${bits[@]}")
    echo "${bits[@]}"

}

convert() {
    local ibase=$1 digits=$2 obase=$3

    case $ibase-$obase in
    2-10)
        binary_to_decimal "$2"
        ;;
    10-2)
        decimal_to_binary "$2"
        ;;
    esac
}

main() {
    convert "$@"
}

main "$@"
