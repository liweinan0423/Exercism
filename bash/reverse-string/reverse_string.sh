#!/usr/bin/env bash

reverse() {
    for ((i = ${#1} - 1; i >= 0; i--)); do
        echo -n "${1:$i:1}"
    done
}

reverse "$@"
