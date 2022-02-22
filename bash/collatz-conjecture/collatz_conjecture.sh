#!/usr/bin/env bash
die() {
    echo "$1"
    exit 1
}

declare -i number=$1 step=0

((number > 0)) || die "Error: Only positive numbers are allowed"

until ((number == 1)); do
    ((number > 0)) || die "Error: Number Overflow: $number, try a smaller number"
    if ((number % 2 == 0)); then
        ((number /= 2))
    else
        ((number = 3 * number + 1))
    fi
    ((step++))
done

echo "$step"
