#!/usr/bin/env bash

die() {
    echo "$1" >&2
    exit 1
}

classify() {
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
    for ((i = 1; i * i < $1; i++)); do
        if (($1 % i == 0)); then
            factors[$i]=1
            factors[$(($1 / i))]=1
        fi
    done
    unset "factors[$1]"
    echo "${!factors[@]}"
}

main() {
    (($1 > 0)) || die "Classification is only possible for natural numbers."
    classify "$1"
}

main "$@"
