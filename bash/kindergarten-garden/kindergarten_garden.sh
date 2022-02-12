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

plant_name() {
    case $1 in
    R) echo radishes ;;
    C) echo clover ;;
    V) echo violets ;;
    G) echo grass ;;
    esac
}

student_id() {
    case $1 in
    Alice) echo 0 ;;
    Bob) echo 1 ;;
    Charlie) echo 2 ;;
    David) echo 3 ;;
    Eve) echo 4 ;;
    Fred) echo 5 ;;
    Ginny) echo 6 ;;
    Harriet) echo 7 ;;
    Ileana) echo 8 ;;
    Joseph) echo 9 ;;
    Kincaid) echo 10 ;;
    Larry) echo 11 ;;
    esac
}

garden=$1 name=$2
while read -r line; do
    width=${#line}
    while read -rn1 plant; do
        plants+=("$plant")
    done < <(printf "%s" "$line")
done <<<"$garden"

id=$(student_id "$name")

output=()
for i in $((2 * id)) $((2 * id + 1)) $((width + 2 * id)) $((width + 2 * id + 1)); do
    output+=("$(plant_name "${plants[i]}")")
done

echo "${output[*]}"
