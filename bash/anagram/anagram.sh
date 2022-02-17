#!/usr/bin/env bash
main() {
    local target=$1
    local -a candidates
    read -ra candidates <<<"$2"
    local -a anagrams
    for word in "${candidates[@]}"; do
        shopt -s nocasematch
        if [[ ${#word} -eq ${#target} && $word != "$target" ]]; then
            local buf=$word
            for ((idx = 0; idx < ${#target}; idx++)); do
                char=${target:$idx:1}
                buf=${buf/$char/}
            done
            [[ -z $buf ]] && anagrams+=("$word")
        fi
    done

    echo "${anagrams[@]}"
}

main "$@"
