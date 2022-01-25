#!/usr/bin/env bash

declare -a alphabets=({a..z})
declare -A TABLE
declare -i length=${#alphabets[@]}
for ((i = 0, j = ${#alphabets[@]} - 1; i < length / 2; i++, j--)); do
    TABLE[${alphabets[$i]}]=${alphabets[$j]}
    TABLE[${alphabets[$j]}]=${alphabets[$i]}
done

declare -r GROUP_SIZE=5

atbash() {
    local text=${1,,} result char
    local -i i
    for ((i = 0; i < ${#text}; i++)); do
        char=${text:$i:1}
        case "$char" in
        [[:alpha:]])
            result+=${TABLE[$char]}
            ;;
        [[:digit:]])
            result+=$char
            ;;
        esac
    done
    echo "$result"
}

format() {
    local formatted
    while read -r -n${GROUP_SIZE} group && [[ -n $group ]]; do
        formatted+="${group} "
    done <<<"$1"
    echo "${formatted% }"
}

main() {
    local cmd=$1 text=$2 result
    case $cmd in
    encode) format "$(atbash "${text}")" ;;
    decode) atbash "${text}" ;;
    esac
}

main "$@"
