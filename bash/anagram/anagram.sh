#!/usr/bin/env bash
main() {
    local target=$1
    read -ra candidates <<<"$2"
    set -- "${candidates[@]}"
    for word; do is_anagram && anagrams+=("$word"); done
    echo "${anagrams[@]}"
}

is_anagram() {
    shopt -s nocasematch
    if [[ ${#word} -eq ${#target} && $word != "$target" ]]; then
        local buf=$word
        for ((idx = 0; idx < ${#target}; idx++)); do
            char=${target:$idx:1}
            buf=${buf/$char/}
        done
        [[ -z $buf ]]
    else
        false
    fi
}

main "$@"
