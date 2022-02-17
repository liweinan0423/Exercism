#!/usr/bin/env bash

die() {
    echo "$@"
    exit 1
}

calculate() {
    local -n __operators=$1 __operand=$2
    local op1=${__operators[0]} op2=${__operators[1]}
    local -i result
    case $__operand in
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

    __operators=("$result")
    __operand=
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

parse() {
    local token=$1
}

main() {
    local -a tokens
    read -ra tokens <<<"${1%"?"}"
    local -a operators
    local operand

    for token in "${tokens[@]}"; do
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
        elif is_noise "$token"; then
            continue
        else
            die "unknown operation"
        fi
        if [[ ${#operators[@]} -eq 2 && -n $operand ]]; then
            calculate operators operand
        fi
    done

    [[ ${#operators[@]} -eq 1 && -z $operand ]] || die "syntax error"
    echo "${operators[0]}"
}

main "$@"
