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
    positive_row && positive_column &&
        ((w[0] < 8 && b[0] < 8)) || die "row not on board"
    ((w[1] < 8 && b[1] < 8)) || die "column not on board"
    ((w[0] != b[0] && w[1] && b[1])) || die "same position"
}

positive_row() {
    ((w[0] >= 0 && b[0] >= 0)) || die "row not positive"
}

positive_column() {

    ((w[1] >= 0 && b[1] >= 0)) || die "column not positive"
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
