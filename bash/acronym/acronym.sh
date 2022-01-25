#!/usr/bin/env bash

main() {
    declare acronym=""

    local IFS=" -"
    read -ra words <<< "$*"
    for word in "${words[@]}"; do
        word=${word//[^[:alpha:]]/}
        acronym+="${word:0:1}"
    done
    echo "${acronym^^}"
}

main "$@"
