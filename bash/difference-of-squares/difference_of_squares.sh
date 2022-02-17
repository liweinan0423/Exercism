#!/usr/bin/env bash
# shellcheck disable=SC2086

main() {
    $1 $2
}

square_of_sum() {
    local -i result
    for ((i = 1; i <= $1; i++)); do
        ((result += i))
    done
    echo $((result * result))
}

sum_of_squares() {
    local -i result
    for ((i = 1; i <= $1; i++)); do
        ((result += i * i))
    done

    echo $result
}

## time complexity: O(n)
difference() {
    echo $(($(square_of_sum $1) - $(sum_of_squares $1)))
}

## (n1 + n2 + ... + nk)^2 = n1^2 + n2^2 + n3^2 + ... + nk^2 +
##                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
##                                                           2*n1*n2 + 2*n1*n3 + ... + 2*n1*nk +
##                                                           2*n2*n3 + 2*n2*n4 + ... * 2*n2*nk +
##                                                           ... +
##                                                           2*n(k-1)*nk
## time complexity: O(n^2)
difference2() {
    local -i sum
    for ((i = 0; i <= $1; i++)); do
        for ((j = i + 1; j <= $1; j++)); do
            ((sum += 2 * i * j))
        done
    done
    echo $sum
}

main "$@"
