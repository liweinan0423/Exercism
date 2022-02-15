#!/usr/bin/env bash

source ./utils.sh

main() {
    local -a winners=("$1")

    for hand; do
        case $(compare "$hand" "${winners[0]}") in
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
declare -rA Priorities=(
    [straight_flush]=1
    [four_of_a_kind]=2
    [full_house]=3
    [flush]=4
    [straight]=5
    [three_of_a_kind]=6
    [two_pairs]=7
    [one_pair]=8
    [high_card]=9
)
compare() {
    local -a hand1 hand2
    local category1 category2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"
    category1=${hand1[0]}
    category2=${hand2[0]}
    if ((${Priorities[$category1]} < ${Priorities[$category2]})); then
        echo win
    elif ((${Priorities[$category1]} > ${Priorities[$category2]})); then
        echo loose
    else
        # compare in the same category
        "compare_$category1" "$1" "$2"
    fi
}

compare_high_card() {
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

hand::group() {
    local -A group
    local hand=$1
    local -a cards
    read -ra cards <<<"$hand"

    for card in "${cards[@]}"; do
        ((group[${card%?}] += 1))
    done
}

declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks

for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done
unset seq

sort_hand() {
    local -n __sorted=$2
    local -a cards
    read -ra cards <<<"$1"
    mapfile -t __sorted < <(for card in "${cards[@]}"; do
        echo "${Ranks[${card%?}]}${card:(-1)}" # <rank> <suit>
    done | sort -k1,1rn)
}

main "$@"
