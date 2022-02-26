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
    local -i numerator=$1 demoninator=$2 gcd
    if ((numerator == 0)); then
        demoninator=1
    else
        gcd=$(gcd $numerator $demoninator)
        ((numerator /= gcd))
        ((denominator /= gcd))
    fi
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

abs() {
    if (($1 >= 0)); then
        echo $1
    else
        echo $((-$1))
    fi
}

gcd() {
    local -i a b min
    a=$(abs $1)
    b=$(abs $2)
    ((a <= b)) && min=$a || min=$b
    ((min != 0)) || return 1
    local -i i
    for ((i = min; i > 0; i--)); do
        if ((a % i == 0 && b % i == 0)); then
            echo $i
            return
        fi
    done

    echo "Why are you here?" >&2
    return 1
}

main "$@"
