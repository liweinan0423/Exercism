#!/usr/bin/env bash

pascal_triangle() {
    local -i n=$1

    local -a prev=() row=()
    for ((i = 0; i < n; i++)); do
        for ((j = 0; j < i + 1; j++)); do
            if ((j == 0 || j == i)); then
                row[j]=1
            else
                row[j]=$((prev[j - 1] + prev[j]))
            fi
        done
        for ((k = 0; k < n - i - 1; k++)); do
            echo -n " "
        done
        echo "${row[@]}"
        prev=("${row[@]}")
    done
}

pascal_triangle "$@"
