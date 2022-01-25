#!/usr/bin/env bash

main() {
    local statement="${1//[[:space:]]/}" # strip all spaces in the statement
    local -i question=0 yelling=0 saying_nothing=0

    [[ $statement =~ \?$ ]] && question=1
    [[ ${statement//[^[:alpha:]]/} =~ ^[A-Z]+$ ]] && yelling=1
    [[ -z ${statement} ]] && saying_nothing=1

    case "${question}${yelling}${saying_nothing}" in
    "100")
        echo "Sure."
        ;;
    "010")
        echo "Whoa, chill out!"
        ;;
    "110")
        echo "Calm down, I know what I'm doing!"
        ;;
    "001")
        echo "Fine. Be that way!"
        ;;
    *)
        echo "Whatever."
        ;;
    esac
}

main "$@"
