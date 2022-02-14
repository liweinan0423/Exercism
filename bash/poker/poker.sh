#!/usr/bin/env bash

declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks

for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done
unset seq

main() {
    local -a winners=("$1")

    local result
    for hand; do
        result=$(compare "$hand" "${winners[0]}")
        case $result in
        win)
            winners=("$hand")
            ;;
        tie)
            [[ $hand != "${winners[0]}" ]] && winners+=("$hand")
            ;;
        esac
    done
    local IFS=$'\n'
    echo "${winners[*]}"
}

compare() {
    local -a sorted1 sorted2
    sort_hand "$1" sorted1
    sort_hand "$2" sorted2
    winner=$(cat <(echo "${sorted1[@]%?}") <(echo "${sorted2[@]%?}") | sort -rn | head -n1)
    looser=$(cat <(echo "${sorted1[@]%?}") <(echo "${sorted2[@]%?}") | sort -rn | tail -n1)
    if [[ $winner == "$looser" ]]; then
        echo tie
    elif [[ $winner == "${sorted1[*]%?}" ]]; then
        echo win
    else
        echo loose
    fi
}

sort_hand() {
    local -n __sorted=$2
    local -a cards
    read -ra cards <<<"$1"
    mapfile -t __sorted < <(for card in "${cards[@]}"; do
        echo "${Ranks[${card%?}]}${card:(-1)}" # <rank> <suit>
    done | sort -k1,1rn)
}

main "$@"
