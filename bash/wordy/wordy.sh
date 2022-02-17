#!/usr/bin/env bash

main() {
    #shellcheck disable=SC2086
    set -- ${1%"?"} #remove trailing quesiton mark, and split into words
    for token; do parse && calculate; done && output
}

parse() {
    if is_operand2 "$token"; then
        if ((${#operands[@]} == 0)); then
            operands+=("$token")
        elif ((${#operands[@]} == 1)) && [[ -n $operator ]]; then
            operands+=("$token")
        else
            die "syntax error"
        fi
    elif is_operand "$token"; then
        if [[ -z $operator ]] && ((${#operands[@]} == 1)); then
            operator=$token
        else
            die "syntax error"
        fi
    elif ! is_nop "$token"; then
        die "unknown operation"
    fi
}

calculate() {
    local -i op1 op2
    local -i result
    if [[ ${#operands[@]} -eq 2 && -n $operator ]]; then
        op1=${operands[0]} op2=${operands[1]}
        case $operator in
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
        operands=("$result")
        operator=
    fi
}

output() {
    [[ ${#operands[@]} -eq 1 && -z $operator ]] || die "syntax error"
    echo "${operands[0]}"
}

is_operand2() {
    [[ $1 =~ -?[0-9]+ ]]
}

is_operand() {
    [[ $1 == @(plus|minus|multiplied|divided) ]]
}

is_nop() {
    [[ $1 == @(What|is|by) ]]
}

die() {
    echo "$@"
    exit 1
}

main "$@"
