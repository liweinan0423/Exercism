#!/usr/bin/env bash

die() {
    echo "$@"
    exit 1
}

calculate() {
    local op1=$1 operand=$2 op2=$3
    case $operand in
    plus)
        echo $((op1 + op2))
        ;;
    minus)
        echo $((op1 - op2))
        ;;
    multiplied)
        echo $((op1 * op2))
        ;;
    divided)
        echo $((op1 / op2))
        ;;
    esac
}

is_operator() {
    [[ $1 =~ -?[0-9]+ ]]
}

is_operand() {
    [[ $1 == @(plus|minus|multiplied|divided) ]]
}

main() {
    local -a tokens
    read -ra tokens <<<"${1%"?"}"
    local -a operators
    local operand

    local -i tmp
    for token in "${tokens[@]}"; do
        if is_operator "$token"; then
            if ((${#operators[@]} == 0)); then
                operators+=("$token")
            elif ((${#operators[@]} == 1)) && [[ -n $operand ]]; then
                tmp=$(calculate "${operators[0]}" "$operand" "$token")
                operators=("$tmp")
                operand=
            else
                die "syntax error"
            fi
        elif is_operand "$token"; then
            if [[ -z $operand ]] && ((${#operators[@]} == 1)); then
                operand=$token
            else
                die "syntax error"
            fi
        elif [[ $token == @(What|is|by) ]]; then
            continue
        else
            die "unknown operation"
        fi
    done

    [[ ${#operators[@]} -eq 1 && -z $operand ]] || die "syntax error"
    echo "${operators[0]}"
}

main "$@"
