#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    case $cmd in
    encode | decode) $cmd "$@" ;;
    esac
}

encode() {
    local decimal=$((16#$1))
    local -a digits=()
    ((decimal == 0)) && digits=(0)
    while ((decimal > 0)); do
        digits=("$((decimal % 128))" "${digits[@]}")
        ((decimal /= 128))
    done

    for ((i = 0; i < ${#digits[@]}; i++)); do
        if ((i != ${#digits[@]} - 1)); then
            printf -v digits[i] "%02X" $((digits[i] ^ 128))
        else
            printf -v digits[i] "%02X" "${digits[i]}"
        fi
    done

    echo "${digits[@]}"
}

main "$@"
