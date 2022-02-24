#!/usr/bin/env bash


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

    if ((ibase != 10)); then
        digits=$(to_decimal "$digits" "$ibase")
    fi
    decimal_to_base "$digits" "$obase"
}

to_decimal() {
    local digits=${1//\ /} base=$2
    local -i result
    while [[ -n $digits ]]; do
        order=$((${#digits} - 1))
        n=${digits:0:1}
        ((result += (n * (base ** order))))
        digits=${digits#?}
    done

    local -a output
    for ((i = 0; i < ${#result}; i++)); do
        output+=("${result:i:1}")
    done

    echo "${output[*]}"
}

main() {
    convert "$@"
}

main "$@"
