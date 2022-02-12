#!/usr/bin/env bash

plant() {
    case $1 in
    R) echo radishes ;;
    C) echo clover ;;
    V) echo violets ;;
    G) echo grass ;;
    esac
}

student() {
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

input=$1 name=$2
while read -r line; do
    width=${#line}
    while read -rn1 plant; do
        garden+=("$plant")
    done < <(printf "%s" "$line")
done <<<"$input"

id=$(student "$name")
offsets=($((2 * id)) $((2 * id + 1)) $((width + 2 * id)) $((width + 2 * id + 1)))
for offset in "${offsets[@]}"; do
    output+=("$(plant "${garden[offset]}")")
done

echo "${output[*]}"
