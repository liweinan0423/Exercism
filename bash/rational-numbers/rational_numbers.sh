#!/usr/bin/env bash

# shellcheck disable=SC2086

main() {
    local op=$1
    shift
    case $op in
    +)
        add "$@"
        ;;
    -)
        subtract "$@"
        ;;
    "*")
        multiply "$@"
        ;;
    esac
}

function add {
    local a=$1 b=$2

    local numerator demoninator

    numerator=$(($(numerator $a) * $(demoninator $b) + $(numerator $b) * $(demoninator $a)))

    demoninator=$(($(demoninator $a) * $(demoninator $b)))

    rational_number $numerator $demoninator
}

function subtract {
    local a=$1 b=$2
    local numerator demoninator

    numerator=$(($(numerator $a) * $(demoninator $b) - $(numerator $b) * $(demoninator $a)))

    demoninator=$(($(demoninator $a) * $(demoninator $b)))

    rational_number $numerator $demoninator
}

function multiply {
    local a=$1 b=$2
    local numerator demoninator

    numerator=$(($(numerator $a) * $(numerator $b)))

    demoninator=$(($(demoninator $a) * $(demoninator $b)))

    rational_number $numerator $demoninator
}

rational_number() {
    local -i numerator=$1 demoninator=$2
    ((numerator == 0)) && demoninator=1
    echo "$numerator/$demoninator"
}

numerator() {
    if [[ $1 =~ (.*)/.* ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

demoninator() {
    if [[ $1 =~ .*/(.*) ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

main "$@"
