#!/usr/bin/env bash

header() {
    row "Team" "MP" "W" "D" "L" "P"
}

row() {
    printf "%-30s | %2s | %2s | %2s | %2s | %2s\n" "$@"
}

main() {
    local -A tally=() # tally=([Team]="MP W D L P"))

    header

    local -i mp1 w1 d1 l1 p1 \
        mp2 w2 d2 l2 p2
    while
        IFS=';'
        read -r home away result && [[ -n $home ]]
    do
        read -r mp1 w1 d1 l1 p1 <<<"${tally[$home]}"
        read -r mp2 w2 d2 l2 p2 <<<"${tally[$away]}"
        ((mp1++))
        ((mp2++))
        case $result in
        win)
            ((w1++))
            ((l2++))
            ((p1 += 3))
            ;;
        loss)
            ((l1++))
            ((w2++))
            ((p2 += 3))
            ;;
        draw)
            ((d1++))
            ((d2++))
            ((p1++))
            ((p2++))
            ;;
        esac

        tally[$home]="$mp1;$w1;$d1;$l1;$p1"
        tally[$away]="$mp2;$w2;$d2;$l2;$p2"

    done

    for team in "${!tally[@]}"; do
        IFS=';'
        read -r mp w d l p <<<"${tally[$team]}"
        row "$team" "$mp" "$w" "$d" "$l" "$p"
    done | sort -t"|" -k6,6nr -k1,1
}

if [[ -t 0 ]]; then
    exec 0<"$1" # attach file to stdin
fi
main
