#!/usr/bin/env bash

check() {
    (($1 > 0 && $2 > 0 && $3 > 0)) || return 1
    (($1 == $2 && $2 == $3)) && echo equilateral
    (($1 != $2 && $2 != $3)) && echo scalene
}

main() {
    if [[ $(check $2 $3 $4) == "$1" ]]; then
        echo true
    else
        echo false
    fi
}

main "$@"
