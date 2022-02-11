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

        if [[ -z $char ]]; then
            result+=$(pop "${buf[@]}")
            buf=()
        fi
    done < <(printf "%s" "$1")

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
