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
        printf "%*s" $((n - i)) ""
        echo "${row[@]}"
    done
}

pascal_triangle "$@"
