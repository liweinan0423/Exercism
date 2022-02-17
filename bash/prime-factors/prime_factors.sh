#!/usr/bin/env bash

main() {
    quotient=$1
    local -a factors
    while ((quotient > 1)); do
        for ((i = 2; i <= $1; i++)); do
            if ((quotient % i == 0)); then
                ((quotient = quotient / i))
                echo -n "$i"
                ((quotient != 1)) && echo -n " "
                break
            fi
        done
    done

    echo "${factors[@]}"
}

main "$@"
