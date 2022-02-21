#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

main() {
    local start=$1 end=$2
    [[ -z $end ]] && end=$start

    [[ $# -le 2 && -n $start && -n $end ]] || die "1 or 2 arguments expected"
    ((start >= end)) || die "Start must be greater than End"

    local line1 line2
    for ((i = start; i >= end; i--)); do
        line1="$(bottles $i) of beer on the wall, $(bottles $i) of beer."
        line2="$(action $i), $(leftover $i) of beer on the wall."
        line1=${line1^}
        line2=${line2^}
        echo "$line1"
        echo "$line2"
        echo
    done
}

action() {
    (($1 > 0)) && echo "take $(it "$1") down and pass it around" || echo "Go to the store and buy some more"
}
leftover() {
    local -i num=$(($1 > 0 ? $1 - 1 : 99))
    bottles $num
}

it() {
    (($1 == 1)) && echo it || echo one
}
bottles() {
    local output
    if (($1 > 1)); then
        output="$1 bottles"
    elif (($1 == 1)); then
        output="$1 bottle"
    else
        output="no more bottles"
    fi
    echo "$output"
}

main "$@"
