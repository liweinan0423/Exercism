#!/usr/bin/env bash

die() {
    echo "$1" >&2
    exit 1
}

main() {
    convert "$@"
}

convert() {
    local ibase=$1 digits=$2 obase=$3
    ((ibase > 1 && obase > 1)) || die "base should be greater than 1"
    [[ $digits =~ ^[0-9\ ]*$ ]] || die "digits should only contain positive numbers"

    if ! digits=$(to_decimal "$digits" "$ibase"); then
        exit 1
    fi
    digits=$(to_base "$digits" "$obase")

    echo "$digits"
}

function to_decimal {
    local -i base=$2 decimal
    local -a digits output
    read -ra digits <<<"$1"
    for ((i = 0; i < ${#digits[@]}; i++)); do
        ((digits[i] < base)) || die "digit should be less than base"
        ((decimal += digits[i] * (base ** (${#digits[@]} - i - 1))))
    done

    for ((i = 0; i < ${#decimal}; i++)); do
        output+=("${decimal:i:1}")
    done

    echo "${output[@]}"
}

to_base() {
    local decimal=${1//\ /} base=$2
    local -a output
    local -i quotient=$decimal
    until ((quotient == 0)); do
        output=($((quotient % base)) "${output[@]}")
        ((quotient /= base))
    done
    echo "${output[@]}"
}

main "$@"
