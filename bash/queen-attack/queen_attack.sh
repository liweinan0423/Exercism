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

    search_ne || search_se || search_sw || search_nw
}

start_from_white_queen() {
    x=${w[0]}
    y=${w[1]}
}

search_ne() {
    start_from_white_queen
    while not_on_corner ne && ! meet; do
        move_or_stop ne
    done
}

search_se() {
    start_from_white_queen
    while not_on_corner se && ! meet; do
        move_or_stop se
    done
    meet
}

search_sw() {
    start_from_white_queen
    while not_on_corner sw && ! meet; do
        move_or_stop sw
    done
}

search_nw() {
    start_from_white_queen
    while not_on_corner nw && ! meet; do
        move_or_stop nw
    done
}

not_on_corner() {
    case $1 in
    nw) ((x >= 0 && y >= 0)) ;;
    sw) ((x >= 0 && y < 8)) ;;
    se) ((x < 8 && y >= 0)) ;;
    ne) ((x < 8 && y < 8)) ;;
    esac

}

move_or_stop() {
    case $1 in
    nw)
        ((x--))
        ((y--))
        ;;
    sw)
        ((x--))
        ((y++))
        ;;
    se)
        ((x++))
        ((y--))
        ;;
    ne)
        ((x++))
        ((y++))
        ;;
    esac
    meet && return || return 1
}

meet() {
    ((x == b[0] && y == b[1]))
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
