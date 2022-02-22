#!/usr/bin/env bash

die() {
    echo "$1" >&2
    exit 1
}

classify() {
    # local -a factors
    local -i sum
    for i in $(factors "$1"); do
        ((sum += i))
    done
    local class
    ((sum == $1)) && class=perfect
    ((sum > $1)) && class=abundant
    ((sum < $1)) && class=deficient
    echo "$class"
}

factors() {
    local -a factors
    factors[1]=1
    for ((i = 2; i < $1; i++)); do
        if ((factors[i])); then
            break
        fi
        if (($1 % i == 0)); then
            factors[$i]=1
            factors[$(($1 / i))]=1
        fi
    done
    echo "${!factors[@]}"
}

main() {
    (($1 > 0)) || die "Classification is only possible for natural numbers."
    classify "$1"
}

main "$@"
