#!/usr/bin/env bash

main() {
    local opt OPTIND OPTARG
    local -a w b
    while getopts 2>/dev/null w:b: opt; do
        case $opt in
        w)
            parse w "$OPTARG"
            ;;
        b)
            parse b "$OPTARG"
            ;;
        *) usage ;;
        esac
    done

    validate
    can_attack
}

can_attack() {
    same_row || same_column || on_diagonal && echo true || echo false
}

same_row() {
    ((w[0] == b[0]))
}

same_column() {
    ((w[1] == b[1]))
}

on_diagonal() {
    local -i x y

    (($(abs "${w[0]}" "${b[0]}") == $(abs "${w[1]}" "${b[1]}")))
}

abs() {
    if (($1 - $2 > 0)); then
        echo $(($1 - $2))
    else
        echo $(($2 - $1))
    fi
}

validate() {
    ((${#w[@]} == 2 && ${#b[@]} == 2)) || usage
    positive_row
    positive_column
    row_on_board
    column_on_board
    different_position
}

positive_row() {
    ((w[0] >= 0 && b[0] >= 0)) || die "row not positive"
}

positive_column() {
    ((w[1] >= 0 && b[1] >= 0)) || die "column not positive"
}

row_on_board() {
    ((w[0] < 8 && b[0] < 8)) || die "row not on board"
}

column_on_board() {
    ((w[1] < 8 && b[1] < 8)) || die "column not on board"
}

different_position() {
    ! same_row || ! same_column || die "same position"
}

die() {
    echo "$1"
    exit 1
}

usage() {
    echo "Usage: ${0##*/} -w <x>,<y> -b <x>,<y>"
    exit 1
}

# shellcheck disable=SC2034
parse() {
    local -n __ary=$1

    local -i x y
    if [[ $2 =~ (-?[0-9]+),(-?[0-9]+) ]]; then
        x=${BASH_REMATCH[1]}
        y=${BASH_REMATCH[2]}
        __ary=("$x" "$y")
    fi
}

main "$@"
