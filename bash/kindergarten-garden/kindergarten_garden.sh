#!/usr/bin/env bash

declare -rA Plants=(
    [R]=radishes
    [V]=violets
    [C]=clover
    [G]=grass
)

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

# given rows of plots like
#   VRCG
#   GRGV
# convert it into array like ("VRGR" "CGGV"), where every element in the array holds the plants for a single student
parse() {
    local -n __garden=$2

    {
        read -r row1
        read -r row2
    } <<<"$1"

    while [[ -n $row1 ]]; do
        __garden+=("${row1:0:2}${row2:0:2}")
        row1=${row1#??}
        row2=${row2#??}
    done

}

expand() {
    for ((i = 0; i < ${#1}; i++)); do
        code=${1:i:1}
        output+=("${Plants[$code]}")
    done

    echo "${output[@]}"
}

main() {
    local input=$1 name=$2
    local -a gardent

    parse "$input" gardent
    expand "${gardent[${Students[$name]}]}"
}

main "$@"
