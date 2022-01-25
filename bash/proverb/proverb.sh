#!/usr/bin/env bash

proverb() {
    for ((i = 1, j = 2; i < $#; i++, j++)); do
        echo "For want of a ${!i} the ${!j} was lost."
    done
    # local -a words=("$@")
    # for ((i = 0; i < ${#words[@]} - 1; i++)); do
    #     echo "For want of a ${words[i]} the ${words[i + 1]} was lost."
    # done
    [[ -n $1 ]] && echo "And all for the want of a $1." || :
}

main() {
    proverb "$@"
}

main "$@"
