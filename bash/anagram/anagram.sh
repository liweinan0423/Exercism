#!/usr/bin/env bash
main() {
    local target=$1
    read -ra candidates <<<"$2"
    set -- "${candidates[@]}"
    for word; do is_anagram && anagrams+=("$word"); done
    echo "${anagrams[@]}"
}

is_anagram() {
    [[ ${word,,} != "${target,,}" && $(ordered "${target,,}") == $(ordered "${word,,}") ]]
}

ordered() {
    echo "$1" | grep -o . | sort | paste -sd " " -
}

main "$@"
