#!/usr/bin/env bash

main() {
    quotient=$1
    for ((i = 2; i <= $1; i++)); do
        if ((quotient % i == 0)); then
            ((quotient = quotient / i))
            echo -n "$i"
            if ((quotient != 1)); then
                echo -n " "
                i=1
            else
                break
            fi
        fi
    done
}

main "$@"
