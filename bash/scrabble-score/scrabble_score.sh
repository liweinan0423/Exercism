#!/usr/bin/env bash

main() {
    local word=$1
    local -i score=0
    while read -r -n1 letter; do
        case ${letter^} in
        [AEIOULNRST])
            ((score++))
            ;;
        [DG])
            ((score += 2))
            ;;
        [BCMP])
            ((score += 3))
            ;;
        [FHVWY])
            ((score += 4))
            ;;
        [K])
            ((score += 5))
            ;;
        [JX])
            ((score += 8))
            ;;
        [QZ])
            ((score += 10))
            ;;
        esac
    done <<<"$word"

    echo $score
}

main "$@"
