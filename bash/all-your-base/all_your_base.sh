#!/usr/bin/env bash

binary_to_decimal() {
    local bin=${1//\ /}
    local -i result
    while [[ $bin =~ ^0*1(.*)$ ]]; do
        offset=${#BASH_REMATCH[1]}
        ((result+=(2 ** offset)))
        bin=${BASH_REMATCH[1]}
    done

    echo $result
}

decimal_to_binary() {
    local decimal=${1//\ /}
    local -a bits

    until ((decimal == 1)); do
        bits=($((decimal % 2)) "${bits[@]}")
        ((decimal/=2))
    done
    bits=(1 "${bits[@]}")
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
    esac
}

main() {
    convert "$@"
}

main "$@"


