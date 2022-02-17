#!/usr/bin/env bash

main() {
    #shellcheck disable=SC2086
    set -- ${1%"?"} #remove trailing quesiton mark, and split into words
    for token; do parse && calculate; done && output
}

parse() {
    if is_operator "$token"; then
        if ((${#operators[@]} == 0)); then
            operators+=("$token")
        elif ((${#operators[@]} == 1)) && [[ -n $operand ]]; then
            operators+=("$token")
        else
            die "syntax error"
        fi
    elif is_operand "$token"; then
        if [[ -z $operand ]] && ((${#operators[@]} == 1)); then
            operand=$token
        else
            die "syntax error"
        fi
    elif ! is_noise "$token"; then
        die "unknown operation"
    fi
}

calculate() {
    local -i op1 op2
    local -i result
    if [[ ${#operators[@]} -eq 2 && -n $operand ]]; then
        op1=${operators[0]} op2=${operators[1]}
        case $operand in
        plus)
            result=$((op1 + op2))
            ;;
        minus)
            result=$((op1 - op2))
            ;;
        multiplied)
            result=$((op1 * op2))
            ;;
        divided)
            result=$((op1 / op2))
            ;;
        esac
        operators=("$result")
        operand=
    fi
}

output() {
    [[ ${#operators[@]} -eq 1 && -z $operand ]] || die "syntax error"
    echo "${operators[0]}"
}

is_operator() {
    [[ $1 =~ -?[0-9]+ ]]
}

is_operand() {
    [[ $1 == @(plus|minus|multiplied|divided) ]]
}

is_noise() {
    [[ $1 == @(What|is|by) ]]
}

die() {
    echo "$@"
    exit 1
}

main "$@"
