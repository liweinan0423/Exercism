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

# is_prime() {

#     local -i n=$1
#     if ((n == 2 || n == 3)); then
#         true
#         return
#     fi
#     if ((n <= 1 || n % 2 == 0 || n % 3 == 0)); then
#         false
#         return 1
#     fi
#     for ((i = 5; i * i <= n; i += 6)); do
#         if ((n % i == 0 || n % (i + 2) == 0)); then
#             false
#             return 1
#         fi
#     done
#     true
# }

main() {
    (($1 > 0)) || die "Classification is only possible for natural numbers."
    classify "$1"
}

main "$@"
