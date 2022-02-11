#!/usr/bin/env bash

# recursive solution
bsearch() {

    local -i key=$1 start=$2 end=$3

    if ((start > end)); then
        echo -1
        return
    fi

    shift 3
    local -a array=("$@")
    local -i midpoint=$(((start + end) / 2))

    if ((key == array[midpoint])); then
        echo "$midpoint"
    elif ((key < array[midpoint])); then
        bsearch2 "$key" "$start" $((midpoint - 1)) "${array[@]}"
    else
        bsearch2 "$key" $((midpoint + 1)) "$end" "${array[@]}"
    fi
}

# iterative solution
bsearch_iter() {
    local -i key=$1
    shift
    local -a array=("$@")

    local -i start=0 end=$((${#array[@]} - 1))
    local -i midpoint result
    local found=false
    until ((start > end)) || $found; do
        midpoint=$(((start + end) / 2))
        if ((key == array[midpoint])); then
            result=$midpoint
            found=true
        elif ((key < array[midpoint])); then
            end=$((midpoint - 1))
        else
            start=$((midpoint + 1))
        fi
    done

    $found && echo $result || echo -1
}

main() {
    local key=$1
    shift
    local -a array=("$@")
    # bsearch "$key" 0 $((${#array[@]} - 1)) "${array[@]}"
    bsearch_iter "$key" "${array[@]}"
}

main "$@"
