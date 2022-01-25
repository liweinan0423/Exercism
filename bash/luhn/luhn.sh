#!/usr/bin/env bash

luhn() {
    local -ra checksum=(0 2 4 6 8 1 3 5 7 9)
    local number=$1
    local -i i d sum
    for ((i = ${#number} - 1, d = 0; i >= 0; i--, d = !d)); do
        local digit=${number:i:1}
        ((sum += (d ? checksum[digit] : digit)))
    done
    ((sum % 10 == 0))
}

quit() {
    echo false
    exit 0
}

main() {
    local number=${1//[[:space:]]/}
    [[ ${#number} -gt 1 && ${number} == +([[:digit:]]) ]] || quit

    if luhn "$number"; then
        echo true
    else
        echo false
    fi

}
main "$@"
