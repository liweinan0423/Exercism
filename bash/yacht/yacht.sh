#!/usr/bin/env bash

main() {
    local category=$1

    shift
    case $category in
    yacht)
        is_yacht "$@" &&
            echo 50 ||
            echo 0
        ;;
    esac
}

is_yacht() {
    (($1 == $2 && $1 == $3 && $1 == $4 && $1 == $5))
}

main "$@"
