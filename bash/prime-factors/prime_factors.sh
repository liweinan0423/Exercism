#!/usr/bin/env bash

main() {
    quotient=$1
    for ((i = 2; i <= $1 && quotient > 1; i++)); do
        if ((quotient % i == 0)); then
            ((quotient = quotient / i))
            echo -n "$i"
            ((quotient != 1)) && echo -n " "
            i=1
        fi
    done
}

main "$@"
