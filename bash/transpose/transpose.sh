#!/usr/bin/env bash

main() {
    local -i width
    local -a lines
    while IFS= read -r line; do
        if ((${#line} > width)); then width=${#line}; fi
        lines+=("$line")
    done

    local -a transposed
    local currentLine char spaces


    # scan the input column by column
    for ((i = 0; i < width; i++)); do
        currentLine=
        spaces=
        for line in "${lines[@]}"; do
            char=${line:i:1}

            # if we read a "hole", push a space into the buffer
            if [[ -z $char ]]; then
                spaces+=" "
            # when we read a character, the previous "holes" must be filled with spaces 
            else
                currentLine+="${spaces}${char}"
                # the buffer should be reset after each fill
                spaces=
            fi
        done
        transposed+=("$currentLine")
    done

    printf "%s\n" "${transposed[@]}"
}

main "$@"
