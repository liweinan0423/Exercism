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

garden=$1 name=$2
while read -r line; do
    width=${#line}
    while read -rn1 plant; do
        plants+=("$plant")
    done < <(printf "%s" "$line")
done <<<"$garden"

id=${Students[$name]}

output=()
for i in $((2 * id)) $((2 * id + 1)) $((width + 2 * id)) $((width + 2 * id + 1)); do
    plant=${plants[$i]}
    output+=("${dict[$plant]}")
done

echo "${output[*]}"
