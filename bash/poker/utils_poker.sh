#!/usr/bin/env bash

source ./utils_array.sh

# support bi-directional lookup between ranks and values(for comparison)
declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks
for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done

# straight A
# one_pair A 10 9 8
# tow_pairs 2 3 8
# three_of_a_kind 3 A 2
# full_house 3 4
# four_of_a_kind 10 A
# flush H 2 4 6 8 9
# straight_flush S 10
# high_card 10 8 7 5 4
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

    # remove suit from the groups and sort them in descending order
    array::remove ranks "[SHDC]"
    rank::sort ranks

    # check for straight 
    # aces lead to special cases for a straight
    case ${ranks[*]} in
    "A 5 4 3 2")
        straight=5
        ;;
    "A K Q J 10")
        straight=A
        ;;
    *)
        straight=${ranks[-1]}
        for ((i = ${#ranks[@]} - 2; i >= 0; i--)); do
            if ((ranks[i] - 1 == straight)); then
                straight=${ranks[i]}
            else
                straight=
                break
            fi
        done
        ;;
    esac

    local result
    if [[ -n $flush ]] && [[ -z $straight ]]; then
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
    elif [[ -n $straight ]] && [[ -z $flush ]]; then
        result="straight $straight"
    elif [[ -n $straight ]] && [[ -n $flush ]]; then
        result="straight_flush $straight $flush"
    else
        result="high_card ${ranks[*]}"
    fi
    echo "${result}"
}

ranks::compare() {
    local -a ranks1 ranks2
    read -ra ranks1 <<<"$1"
    read -ra ranks2 <<<"$2"
    local -a values1 values2
    for ((i = 0; i < ${#ranks1[@]}; i++)); do
        r1=${ranks1[$i]}
        r2=${ranks2[$i]}
        values1+=("${Ranks[$r1]}")
        values2+=("${Ranks[$r2]}")
    done
    array::compare values1 values2
}

rank::sort() {
    local -n __ranks=$1
    local -a values
    for rank in "${__ranks[@]}"; do
        values+=("${Ranks[$rank]}")
    done

    array::sort values

    __ranks=()
    for val in "${values[@]}"; do
        __ranks+=("${Cards[$val]}")
    done
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

debug() {
    echo 1>&2 "$@"
}

if [[ $1 == "test" ]]; then
    func=$2
    shift 2
    $func "$@"
fi
