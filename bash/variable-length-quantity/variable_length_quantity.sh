#!/usr/bin/env bash

main() {
    local cmd=$1
    shift
    case $cmd in
    encode | decode) $cmd "$@" ;;
    esac
}

encode() {
    echo $1
}

main "$@"
