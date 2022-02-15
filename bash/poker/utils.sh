#!/usr/bin/env bash

declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks

for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done

# straight A
# one_pair A 8 9 10
# tow_pairs 2 3 8
# three_of_a_kind 3 A 2
# full_house 3 4
# four_of_a_kind 10 A
# flush H 2 4 6 8 9
# straight_flush S 10
# high_card 1 3 5 7 9
hand::parse() {
    local -A groups
    hand::group "$1" groups
    local -a pairs
    local triplet quad flush straight
    for key in "${!groups[@]}"; do
        case $key in
        S | H | D | C) # suit groups
            if ((groups[$key] == 5)); then
                flush=$key
            fi
            ;;
        *) # rank groups
            case ${groups[$key]} in
            4)
                quad=$key
                ;;
            3)
                triplet=$key
                ;;
            2)
                pairs+=("$key")
                ;;
            esac
            ;;
        esac
    done
    local -a ranks=("${!groups[@]}")
    array::remove ranks "[SHDC]"
    rank::sort ranks
    straight=${ranks[0]}

    for ((i = 1; i < ${#ranks[@]}; i++)); do
        if ((ranks[i] + 1 == straight)); then
            straight=${ranks[i]}
        else
            straight=0
            break
        fi
    done

    if [[ -n $flush ]] && ((!straight)); then
        result="flush $flush ${ranks[*]}"
    elif [[ -n $triplet ]] && ((${#pairs[@]} == 0)); then
        array::remove ranks "${triplet}"
        result="three_of_a_kind ${triplet} ${ranks[*]}"
    elif [[ -n $triplet ]] && ((${#pairs[@]} == 1)); then
        result="full_house $triplet ${pairs[0]}"
    elif ((${#pairs[@]} == 1)); then
        array::remove ranks "${pairs[0]}"
        result="one_pair ${pairs[0]} ${ranks[*]}"
    elif ((${#pairs[@]} == 2)); then
        array::remove ranks "[${pairs[0]}${pairs[1]}]"
        result="two_pairs ${pairs[*]} ${ranks[*]}"
    elif [[ -n $quad ]]; then
        array::remove ranks "$quad"
        result="four_of_a_kind $quad ${ranks[*]}"
    elif ((straight)) && [[ -z $flush ]]; then
        result="straight $straight"
    elif ((straight)) && [[ -n $flush ]]; then
        result="straight_flush $flush $straight"

    fi
    echo "${result}"
}

array::remove() {
    local -n __ary=$1
    local pattern=$2
    local -a result
    for e in "${__ary[@]}"; do
        # shellcheck disable=SC2053
        if [[ $e != $pattern ]]; then
            result+=("$e")
        fi
    done

    __ary=("${result[@]}")
}

rank::sort() {
    local -n __ranks=$1
    local -a sortedValues sortedRanks
    readarray -t sortedValues < <(for rank in "${__ranks[@]}"; do
        [[ -n $rank ]] && echo "${Ranks[$rank]}"
    done | sort -rn)
    # for rank in "${__ranks[@]}"; do
    #     [[ -n $rank ]] && echo "${Ranks[$rank]}"
    # done | sort -rn
    for val in "${sortedValues[@]}"; do
        sortedRanks+=("${Cards[$val]}")
    done

    __ranks=("${sortedRanks[@]}")
}

hand::group() {
    local -n __groups=$2
    local hand=$1
    local -a cards
    read -ra cards <<<"$hand"

    # grouping ranks
    for rank in "${cards[@]%?}"; do
        ((__groups[$rank] += 1))
    done

    # grouping suits
    for card in "${cards[@]}"; do
        ((__groups[${card:(-1)}] += 1))
    done
}

if [[ $1 == "test" ]]; then
    func=$2
    shift 2
    $func "$@"
fi
