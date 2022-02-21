#!/usr/bin/env bash

main() {
    local opt OPTIND OPTARG
    local -a w b
    while getopts w:b: opt; do
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

    can_attack && echo true || echo false
}

can_attack() {
    same_row || same_column || on_diagonal
}

on_diagonal() {
    local -i x y

    x=${w[0]} y=${w[0]}
    while ((x < 8 && y < 8)); do
        if ((x == b[0] && y == b[1])); then
            return
        else
            ((x++))
            ((y++))
        fi
    done

    x=${w[0]} y=${w[0]}
    while ((x < 8 && y >= 0)); do
        if ((x == b[0] && y == b[1])); then
            return
        else
            ((x++))
            ((y--))
        fi
    done

    x=${w[0]} y=${w[0]}
    while ((x >= 0 && y < 8)); do
        if ((x == b[0] && y == b[1])); then
            return
        else
            ((x--))
            ((y++))
        fi
    done

    x=${w[0]} y=${w[0]}
    while ((x >= 0 && y >= 0)); do
        if ((x == b[0] && y == b[1])); then
            return
        else
            ((x--))
            ((y--))
        fi
    done

    return 1

}

same_row() {
    ((w[0] == b[0]))
}

same_column() {
    ((w[1] == b[1]))
}

validate() {
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
    ((w[0] != b[0] || w[1] != b[1])) || die "same position"
}

die() {
    echo "$1"
    exit 1
}
usage() {
    echo "Usage: ${0##*/} -w <x>,<y> -b <x>,<y>"
}
parse() {
    local -n __ary=$1

    local -i x y
    if [[ $2 =~ (.*),(.*) ]]; then
        x=${BASH_REMATCH[1]}
        y=${BASH_REMATCH[2]}
    fi
    __ary=("$x" "$y")
}

main "$@"
