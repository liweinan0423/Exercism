#!/usr/bin/env bash

main() {
    local -a hands=("$@")
    if ((${#hands[@]} == 1)); then
        echo "${hands[0]}"
        return
    fi
}

main "$@"
