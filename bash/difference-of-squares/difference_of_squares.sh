#!/usr/bin/env bash
# shellcheck disable=SC2086

main() {
    $1 $2
}

# sum of arithmetic progression: n(n+1)/2
# time complexity: O(1)
square_of_sum() {
    echo $((($1 * (1 + $1) / 2) ** 2))
}

# https://www.cuemath.com/algebra/sum-of-squares/
# time complexity: O(1)
sum_of_squares() {
    echo $(($1 * ($1 + 1) * (2 * $1 + 1) / 6))
}

## time complexity: O(1)
difference() {
    echo $(($(square_of_sum $1) - $(sum_of_squares $1)))
}

main "$@"
