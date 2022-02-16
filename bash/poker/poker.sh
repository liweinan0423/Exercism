#!/usr/bin/env bash

source ./utils.sh

main() {
    local -a winners=("$1")
    shift
    for hand; do
        case $(compare "$hand" "${winners[0]}") in
        win)
            winners=("$hand")
            ;;
        tie)
            winners+=("$hand")
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
        "compare_$category1" "$1" "$2"
    fi
}

compare_one_pair() {
    local -a hand1 hand2
    local pair1 pair2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"

    pair1=${hand1[1]}
    pair2=${hand2[1]}

    if ((pair1 > pair2)); then
        echo win
    elif ((pair1 == pair2)); then
        echo tie
    else
        echo loose
    fi

}
compare_flush() {
    compare_high_card "$@"
}

compare_full_house() {
    local -a hand1 hand2
    local pair1 pair2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"

    local triplet1=${hand1[1]} triplet2=${hand2[1]}
    local pair1=${hand1[2]} pair2=${hand2[2]}

    if [[ $(rank::compare "$triplet1" "$triplet2") == tie ]]; then
        rank::compare "$pair1" "$pair2"
    else
        rank::compare "$triplet1" "$triplet2"
    fi
}

compare_three_of_a_kind() {
    local -a hand1 hand2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"
    local triplet1 triplet2
    triplet1=${hand1[1]}
    triplet2=${hand2[1]}

    remainder1=("${hand1[@]:2}")
    remainder2=("${hand2[@]:2}")
    if [[ $(rank::compare "$triplet1" "$triplet2") == tie ]]; then
        array::compare remainder1 remainder2
    else
        rank::compare "$triplet1" "$triplet2"
    fi
}

compare_straight() {
    local -a hand1 hand2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"

    if [[ ${hand1[1]} == A && ${hand2[1]} != A ]]; then
        echo -1
    elif [[ ${hand1[1]} == A && ${hand2[1]} == A ]]; then
        echo 0
    else
        rank::compare "${hand1[1]}" "${hand2[1]}"
    fi
}

compare_two_pairs() {

    local -a hand1 hand2
    local -a pairs1 pairs2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"

    pairs1=("${hand1[@]:1:2}")
    pairs2=("${hand2[@]:1:2}")

    if [[ $(array::compare pairs1 pairs2) == tie ]]; then
        if ((hand1[3] > hand2[3])); then
            echo win
        elif ((hand1[3] == hand2[3])); then
            echo tie
        else
            echo loose
        fi
    else
        array::compare pairs1 pairs2
    fi
}

compare_high_card() {
    local -a hand1 hand2
    read -ra hand1 <<<"$(hand::parse "$1")"
    read -ra hand2 <<<"$(hand::parse "$2")"
    for ((i = 1; i < ${#hand1[@]}; i++)); do
        hand1[$i]=${Ranks[${hand1[$i]}]}
        hand2[$i]=${Ranks[${hand2[$i]}]}
    done

    winner=$(cat <(echo "${hand1[@]}") <(echo "${hand2[@]}") | sort -rn | head -n1)
    looser=$(cat <(echo "${hand1[@]}") <(echo "${hand2[@]}") | sort -rn | tail -n1)

    if [[ $winner == "$looser" ]]; then
        echo tie
    elif [[ $winner == "${hand1[*]}" ]]; then
        echo win
    else
        echo loose
    fi
}

main "$@"
