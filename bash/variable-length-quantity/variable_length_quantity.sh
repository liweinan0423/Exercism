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

encode_number() {
    local -i decimal=$((0x$1))
    local msb=0
    local -a bytes
    while true; do
        bytes=("$(printf "%02X" $((decimal & MASK ^ msb)))" "${bytes[@]}")
        msb=0x80 # 10000000
        ((decimal >>= 7))
        ((decimal == 0)) && break
    done

    echo "${bytes[@]}"
}

decode() {
    local -a group output
    local -i digit
    for code; do
        digit=$((0x$code))
        group+=("$digit")
        if (((digit | 128) != digit)); then # if MSB is 1, (digit | 128) does not change
            output+=("$(decode_group "${group[@]}")")
            group=()
        fi
    done

    if ((${#group[@]} != 0)); then
        echo "incomplete byte sequence: $*" >&2
        exit 1
    fi
    echo "${output[@]}"
}

decode_group() {
    local -a output=("$@")

    local -i decimal
    for ((i = 0; i < ${#output[@]}; i++)); do
        if ((i != ${#output[@]} - 1)); then
            ((decimal = decimal * 128 + (output[i] ^ 128)))
        else
            ((decimal = decimal * 128 + output[i]))
        fi
    done

    printf "%02X" $decimal

}

main "$@"
