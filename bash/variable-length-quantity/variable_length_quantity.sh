#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    case $cmd in
    encode | decode) $cmd "$@" ;;
    *)
        echo "unknown subcommand: $cmd" >&2
        exit 1
        ;;
    esac
}

encode() {
    local -a output
    for number; do
        output+=("$(encode_number "$number")")
    done
    echo "${output[@]}"
}

declare -ri MASK=0x7F #01111111
declare -ri MSB=0x80  #10000000

encode_number() {
    local -i decimal=$((0x$1))
    local msb=0
    local -a bytes
    while true; do
        bytes=("$(printf "%02X" $((decimal & MASK ^ msb)))" "${bytes[@]}")
        msb=$MSB # 10000000
        ((decimal >>= 7))
        ((decimal == 0)) && break
    done

    echo "${bytes[@]}"
}

decode() {
    if (((0x${!#} & MSB) != 0)); then # last positional parameter should have bit #7 clear
        echo >&2 "incomplete byte sequence"
        exit 1
    fi
    local -a output
    local -i number=0
    for byte; do
        ((number = (number << 7) ^ (0x$byte & MASK)))
        if (((0x$byte & MSB) == 0)); then
            output+=("$(printf "%02X" $number)")
            number=0
        fi
    done
    echo "${output[@]}"
}

main "$@"
