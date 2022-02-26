#!/usr/bin/env bash

# shellcheck disable=SC2086,SC2046

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
    "/")
        divide "$@"
        ;;
    abs)
        abs "$@"
        ;;
    pow)
        pow "$@"
        ;;
    rpow)
        rpow "$@"
        ;;
    reduce)
        reduce "$@"
        ;;
    esac
}

function add {
    local a=$1 b=$2

    local numerator denominator

    numerator=$(($(numerator $a) * $(denominator $b) + $(numerator $b) * $(denominator $a)))

    denominator=$(($(denominator $a) * $(denominator $b)))

    reduce $numerator/$denominator
}

function subtract {
    local a=$1 b=$2
    local numerator denominator

    numerator=$(($(numerator $a) * $(denominator $b) - $(numerator $b) * $(denominator $a)))

    denominator=$(($(denominator $a) * $(denominator $b)))

    reduce $numerator/$denominator
}

function multiply {
    local a=$1 b=$2
    local numerator denominator

    numerator=$(($(numerator $a) * $(numerator $b)))

    denominator=$(($(denominator $a) * $(denominator $b)))

    reduce $numerator/$denominator
}

divide() {
    local a=$1 b=$2
    local numerator denominator

    numerator=$(($(numerator $a) * $(denominator $b)))
    denominator=$(($(denominator $a) * $(numerator $b)))

    reduce $numerator/$denominator
}

reduce() {
    local -i numerator denominator gcd
    if (($# == 1)); then
        numerator=$(numerator $1)
        denominator=$(denominator $1)
    else
        numerator=$1
        denominator=$2
    fi
    if ((numerator == 0)); then
        denominator=1
    else
        gcd=$(gcd $numerator $denominator)
        ((numerator /= gcd))
        ((denominator /= gcd))
    fi
    if ((denominator < 0)); then
        numerator=$((-numerator))
        denominator=$((-denominator))
    fi
    echo "$numerator/$denominator"
}

rational_number() {
    reduce "$@"
}

numerator() {
    if [[ $1 =~ (.*)/.* ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

denominator() {
    if [[ $1 =~ .*/(.*) ]]; then
        echo "${BASH_REMATCH[1]}"
    fi
}

abs() {
    if [[ $1 == */* ]]; then
        rational::abs $1
    else
        real::abs $1
    fi
}

pow() {
    local numerator denominator
    numerator=$(numerator $1)
    denominator=$(denominator $1)

    rational_number $((numerator ** $2)) $((denominator ** $2))
}

rpow() {
    local output
    output=$(awk "BEGIN {printf \"%.6f\", $1^($2)}")

    if [[ $output =~ (.*)\.0+$ ]]; then
        echo ${BASH_REMATCH[1]}.0
    else
        echo $output
    fi
}

rational::abs() {
    local -i numerator denominator
    numerator=$(numerator $1)
    denominator=$(denominator $1)

    rational_number $(abs $numerator) $(abs $denominator)
}
real::abs() {
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
