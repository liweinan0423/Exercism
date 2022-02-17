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

difference() {
    echo $(($(square_of_sum $1) - $(sum_of_squares $1)))
}

main "$@"
