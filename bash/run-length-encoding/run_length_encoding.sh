#!/usr/bin/env bash

main() {
    local prev current
    local result
    local -i counter=1
    while read -rn1 current; do
        if [[ $current == "$prev" ]]; then
            ((counter++))
        else
            if ((counter == 1)); then
                result+=$current
            else
                result+="$counter$prev"
            fi
        fi
        prev=$current
    done < <(printf "%s" "$2")

    echo "$result"
}

main "$@"
