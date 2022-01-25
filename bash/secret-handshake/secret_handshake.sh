#!/usr/bin/env bash

declare -ra actions=("wink" "double blink" "close your eyes" "jump")

main() {
    local -a ret=()
    local -i i
    for ((i = 0; i < ${#actions[@]}; i++)); do
        if (($1 & 1 << i)); then
            (($1 & 1 << 4)) && ret=("${actions[i]}" "${ret[@]}") || ret+=("${actions[i]}")
        fi
    done
    local IFS=,
    echo "${ret[*]}"
}

main "$@"
