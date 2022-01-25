#! /usr/bin/env bash

sieve() {
    local -i limit=$1

    local -a numbers primes

    for ((i = 2; i <= limit; i++)); do
        numbers[$i]=1
    done

    for ((p = 2; p <= limit; p++)); do
        if ((numbers[p])); then
            primes+=("$p")
            for ((i = 2 * p; i <= limit; i += p)); do
                numbers[$i]=0
            done
        fi
    done

    echo "${primes[@]}"

}

main() {
    sieve "$@"
}

main "$@"
