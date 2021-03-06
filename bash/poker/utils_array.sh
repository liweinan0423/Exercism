#!/usr/bin/env bash

# remove element(s) from array by pattern
array::remove() {
    local -n __ary=$1
    local pattern=$2
    local -a result
    for e in "${__ary[@]}"; do
        # shellcheck disable=SC2053
        if [[ $e != $pattern ]]; then
            result+=("$e")
        fi
    done

    __ary=("${result[@]}")
}

# sort array in descending order
array::sort() {
    local -n __array=$1
    local -a sorted
    readarray -t sorted <<<"$(sort -rn <(printf "%s\n" "${__array[@]}"))"
    __array=("${sorted[@]}")
}

# compare two desc-sorted array
array::compare() {
    local -n __ary1=$1 __ary2=$2
    local -a sorted1=("${__ary1[@]}") sorted2=("${__ary2[@]}")
    winner=$(cat <(echo "${sorted1[@]}") <(echo "${sorted2[@]}") | sort -rn | head -n1)
    looser=$(cat <(echo "${sorted1[@]}") <(echo "${sorted2[@]}") | sort -rn | tail -n1)
    if [[ $winner == "$looser" ]]; then
        echo 0
    elif [[ $winner == "${sorted1[*]}" ]]; then
        echo 1
    else
        echo -1
    fi
}
