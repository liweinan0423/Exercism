#!/usr/bin/env bash

clock() {
    local h=$1 m=$2 operator=$3 operand=$4
    # shellcheck disable=SC2015
    [[ -n $operator && -n $operand ]] && m=$(("${m}${operator}${operand}")) || :
    local hourRange=({0..23}) minuteRange=({0..59})
    h=${hourRange[$(((h + (m < 0 && m % 60 != 0 ? ((m - 60) / 60) : m / 60)) % 24))]}

    m=${minuteRange[$((m % 60))]}
    printf "%02d:%02d\n" "$h" "$m"
}

die() {
    echo "$1"
    exit 1
}

[[ $# -eq 2 || $# == 4 && $3 == [+-] ]] || die "invalid arguments"
[[ "$1$2" == +([-[:digit:]]) ]] || die "invalid numbers"

clock "$@"
