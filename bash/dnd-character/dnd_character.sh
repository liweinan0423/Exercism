#!/usr/bin/env bash

modifier() {
    local score=$1
    echo $(((score - 10) % 2 == 0 ? (score - 10) / 2 : ((score - 10 - 1) / 2))) # round down after divided by 2
}

roll() {
    local -i roll min=6 sum=0
    for _ in {1..4}; do
        roll=$((RANDOM % 6 + 1))
        if ((roll < min)); then min=$roll; fi
        ((sum += roll))
    done
    echo $((sum - min))
}

generate() {
    local attr val
    for attr in strength dexterity constitution intelligence wisdom charisma; do
        val=$(roll)
        echo "${attr} $val"
        if [[ $attr == "constitution" ]]; then
            echo "hitpoints $((10 + $(modifier "$val")))"
        fi
    done
}

main() {
    case "$1" in
    modifier | generate)
        "$@"
        ;;
    *)
        echo "Usage: ${0##*/} <command> <score>"
        exit 1
        ;;
    esac
}

main "$@"
