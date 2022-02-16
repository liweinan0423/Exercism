#!/usr/bin/env bash

#shellcheck disable=SC2086,SC2046

check() {
    set -- $(handle_float $1) $(handle_float $2) $(handle_float $3)
    (($1 > 0 && $2 > 0 && $3 > 0)) || return 1
    (($1 == $2 && $2 == $3)) && echo equilateral
    (($1 != $2 && $2 != $3)) && echo scalene
}

handle_float() {
    echo ${1/./}
}

main() {
    if [[ $(check $2 $3 $4) == "$1" ]]; then
        echo true
    else
        echo false
    fi
}

main "$@"
