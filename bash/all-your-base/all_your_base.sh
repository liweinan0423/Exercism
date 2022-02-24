#!/usr/bin/env bash

main() {
    convert "$@"
}

convert() {
    local ibase=$1 digits=$2 obase=$3

    if ((ibase != 10)); then
        digits=$(to_decimal "$digits" "$ibase")
    fi
    decimal_to_base "$digits" "$obase"
}

to_decimal() {
    local -i base=$2 decimal
    local -a digits output
    read -ra digits <<<"$1"
    for ((i = 0; i < ${#digits[@]}; i++)); do
        ((decimal += digits[i] * (base ** (${#digits[@]} - i - 1))))
    done

    for ((i = 0; i < ${#decimal}; i++)); do
        output+=("${decimal:i:1}")
    done

    echo "${output[@]}"
}

decimal_to_base() {
    local decimal=${1//\ /} base=$2
    local -a output
    local -i quotient=$decimal
    until ((quotient < base)); do
        output=($((quotient % base)) "${output[@]}")
        ((quotient /= base))
    done
    output=("$quotient" "${output[@]}")
    echo "${output[@]}"
}

main "$@"
