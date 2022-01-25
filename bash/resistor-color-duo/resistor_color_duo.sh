#!/usr/bin/env bash

color() {
    case $1 in
    black)  echo 0 ;;
    brown)  echo 1 ;;
    red)    echo 2 ;;
    orange) echo 3 ;;
    yellow) echo 4 ;;
    green)  echo 5 ;;
    blue)   echo 6 ;;
    violet) echo 7 ;;
    grey)   echo 8 ;;
    white)  echo 9 ;;

    *) exit 1 ;;
    esac
}

die() {
    echo "$1"
    exit 1
}
main() {
    tens=$(color "$1") || die "invalid color"
    ones=$(color "$2") || die "invalid color"
    echo $((tens * 10 + ones))
}

main "$@"
