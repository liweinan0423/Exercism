#!/usr/bin/env bash

pascal_triangle() {
    local -i n=$1

    local -a prev=() row=()
    for ((i = 1; i <= n; i++)); do
        for ((j = 0; j < i; j++)); do
            if ((j == 0 || j == i)); then
                row[j]=1
            else
                row[j]=$((prev[j - 1] + prev[j]))
            fi
        done
        prev=("${row[@]}")
        spaces $((n - i)) && echo "${row[@]}"
    done
}

spaces() {
    local -i i
    for ((i = 0; i < $1; i++)); do
        echo -n " "
    done
}

pascal_triangle "$@"
