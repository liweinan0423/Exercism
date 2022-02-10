#!/usr/bin/env bash

# recursive solution
binary_search() {
    local -a array left right
    local -i arrlen
    local -i midpoint

    local -i offset=$1 key=$2
    shift 2
    array=("$@")
    arrlen=${#array[@]}
    midpoint=$(midpoint "${array[@]}")
    middle=$(middle "${array[@]}")
    read -ra left < <(left "${array[@]}")
    read -ra right < <(right "${array[@]}")

    if ((arrlen == 0)); then
        echo -1
    elif ((key == middle)); then
        echo $((midpoint + offset))
    elif ((key < array[midpoint])); then
        binary_search "$offset" "$key" "${left[@]}"
    elif ((key > array[midpoint])); then
        binary_search $((midpoint + offset + 1)) "$key" "${right[@]}"
    fi
}

midpoint() {
    local len=${#array[@]}
    echo $((len / 2))
}

middle() {
    echo "${array[$(midpoint "$@")]}"
}

left() {
    local midpoint
    local -a array=("$@")
    midpoint=$((${#array[@]} / 2))
    echo "${array[@]:0:midpoint}"
}

right() {
    local midpoint
    local -a array=("$@")
    midpoint=$((${#array[@]} / 2))
    echo "${array[@]:midpoint+1}"
}

# iterative solution
binary_search_iter() {
    local -a array
    local -i arrlen
    local -i midpoint

    local -i offset=0 key=$2
    shift 2
    array=("$@")

    while ((${#array[@]} > 0)); do
        midpoint=$(midpoint "${array[@]}")
        if ((key == array[midpoint])); then
            echo $((midpoint + offset))
            return
        elif ((key < array[midpoint])); then
            read -ra array < <(left "${array[@]}")
        else
            read -ra array < <(right "${array[@]}")
            offset+=$((midpoint + 1))
        fi
    done

    echo -1
}

main() {
    local key=$1
    shift
    local -a array=("$@")
    # binary_search 0 "$key" "${array[@]}"
    binary_search_iter 0 "$key" "${array[@]}"
}

main "$@"
