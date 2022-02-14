#!/usr/bin/env bash

declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks

for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done
unset seq

main() {

    local win=$1
    for hand; do
        if compare_hands "$hand" "$win"; then
            win=$hand
        fi
    done
    echo "$win"
}

compare_hands() {
    local high_left high_right
    high_left=$(highest_rank "$1")
    high_right=$(highest_rank "$2")
    ((high_left > high_right))
}

highest_rank() {
    local hand=$1
    local -a sorted=$2
    sort_hand "$hand" sorted
    echo "${sorted[0]%?}"
}

sort_hand() {
    local -n __sorted=$2
    local -a cards
    read -ra cards <<<"$1"
    mapfile -t sorted < <(for card in "${cards[@]}"; do
        echo "${Ranks[${card%?}]} ${card:(-1)}" # <rank> <suit>
    done | sort -k1,1rn)
}

main "$@"
