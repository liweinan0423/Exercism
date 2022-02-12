#!/usr/bin/env bash

declare -rA Students=(
    [Alice]=0
    [Bob]=1
    [Charlie]=2
    [David]=3
    [Eve]=4
    [Fred]=5
    [Ginny]=6
    [Harriet]=7
    [Ileana]=8
    [Joseph]=9
    [Kincaid]=10
    [Larry]=11
)
declare -A dict=(
    [R]=radishes
    [C]=clover
    [V]=violets
    [G]=grass
)

rows=$1 name=$2
while read -r line; do
    width=${#line}
    while read -rn1 plant; do
        [[ -n $plant ]] && plants+=("$plant")
    done <<<"$line"
done <<<"$rows"

idx=${Students[$name]}

output=()
for i in $((2 * idx)) $((2 * idx + 1)) $((width + 2 * idx)) $((width + 2 * idx + 1)); do
    output+=("${dict[${plants[$i]}]}")
done

echo "${output[*]}"
