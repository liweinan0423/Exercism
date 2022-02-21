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
    for ((i = start; i >= end; i--)); do
        if ((i > 0)); then
            echo "$(bottles $i) of beer on the wall, $(bottles $i) of beer."
            echo "Take $(it $i) down and pass it around, $(bottles $((i - 1))) of beer on the wall."
            echo
        else
            echo "No more bottles of beer on the wall, no more bottles of beer."
            echo "Go to the store and buy some more, 99 bottles of beer on the wall."
        fi
    done
}
it() {
    (($1 == 1)) && echo it || echo one
}
bottles() {
    if (($1 > 1)); then
        echo "$1 bottles"
    elif (($1 == 1)); then
        echo "$1 bottle"
    else
        echo "no more bottles"
    fi
}

main "$@"
