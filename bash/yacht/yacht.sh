#!/usr/bin/env bash

# shellcheck disable=SC2015

main() {
    local category=$1

    shift
    case $category in
    yacht)
        is_yacht "$@" && yacht || zero
        ;;
    ones) ;;

    esac

}

is_yacht() {
    (($1 == $2 && $1 == $3 && $1 == $4 && $1 == $5))
}

yacht() {
    echo 50
}

zero() {
    echo 0
}

main "$@"
