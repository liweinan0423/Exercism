#!/usr/bin/env bash

color() {
    case $1 in
    black) echo 0 ;;
    brown) echo 1 ;;
    red) echo 2 ;;
    orange) echo 3 ;;
    yellow) echo 4 ;;
    green) echo 5 ;;
    blue) echo 6 ;;
    violet) echo 7 ;;
    grey) echo 8 ;;
    white) echo 9 ;;

    *) exit 1 ;;
    esac
}
die() {
    echo "$1"
    exit 1
}

declare -ra units=("ohms" "kiloohms" "megaohms" "gigaohms")

main() {
    local -i n1 n2
    local result zeros

    n1=$(color "$1") || die "invalid color"
    n2=$(color "$2") || die "invalid color"
    zeros=$(color "$3") || die "invalid color"

    result=$(((n1 * 10 + n2) * 10 ** zeros))

    local -i idx=0
    while [[ $result == *000 ]]; do
        ((idx++))
        result=${result%000}
    done

    result="$result ${units[$idx]}"
    echo "$result"
}

main "$@"
