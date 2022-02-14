#!/usr/bin/env bash

declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks

for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done
unset seq

main() {
    local -a winners=("$1")

    for hand; do
        if win "$hand" "${winners[0]}"; then
            winners=("$hand")
        elif tie "$hand" "${winners[0]}"; then
            [[ $hand != "${winners[0]}" ]] && winners+=("$hand")
        fi
    done
    local IFS=$'\n'
    echo "${winners[*]}"
}
tie() {
    (($(highest_rank "$1") == $(highest_rank "$2")))
}

win() {
    (($(highest_rank "$1") > $(highest_rank "$2")))
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
