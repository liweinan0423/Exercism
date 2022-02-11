#!/usr/bin/env bash

main() {
    $1 "$2"
}

encode() {
    local char
    local result
    local -a buf
    while IFS= read -rn1 char || ((${#buf[@]} > 0)); do

        if ((${#buf[@]} == 0)) || [[ $char == "${buf[-1]}" ]]; then
            buf+=("$char")
        else
            result+=$(pop "${buf[@]}")
            buf=("$char")
        fi

        # clear buf at the end
        if [[ -z $char ]]; then
            result+=$(pop "${buf[@]}")
            buf=()
        fi
    done < <(printf "%s" "$1")

    echo "$result"
}

decode() {
    local encoded=$1
    local result
    while [[ $encoded =~ ([0-9]*)([a-zA-Z ])(.*) ]]; do
        count=${BASH_REMATCH[1]}
        char=${BASH_REMATCH[2]}
        remainder=${BASH_REMATCH[3]}
        if [[ -z $count ]]; then
            result+=$char
        else
            for ((i = 0; i < count; i++)); do
                result+=$char
            done
        fi
        encoded=$remainder
    done
    echo "$result"
}

pop() {
    if (($# == 1)); then
        echo "$1"
    else
        echo "$#$1"
    fi
}

main "$@"
