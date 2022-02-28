#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    case $cmd in
    encode | decode) $cmd "$@" ;;
    esac
}

encode() {
    local -a output
    for byte; do
        output+=("$(encode_byte "$byte")")
    done
    echo "${output[@]}"
}

encode_byte() {
    local decimal=$((16#$1))
    local -a digits
    if ((decimal == 0)); then
        digits+=(0)
    else
        while ((decimal > 0)); do
            digits=("$((decimal % 128))" "${digits[@]}")
            ((decimal /= 128))
        done
    fi

    for ((i = 0; i < ${#digits[@]}; i++)); do
        if ((i != ${#digits[@]} - 1)); then
            printf -v digits[i] "%02X" $((digits[i] ^ 128))
        else
            printf -v digits[i] "%02X" "${digits[i]}"
        fi
    done

    echo "${digits[@]}"
}

decode() {
    local -a group output
    local -i digit
    for code; do
        digit=$((16#$code))
        group+=("$digit")
        if (((digit | 128) != digit)); then
            output+=("$(decode_group "${group[@]}")")
            group=()
        fi
    done

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
