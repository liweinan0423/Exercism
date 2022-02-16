#!/usr/bin/env bash

source ./utils_array.sh

# support bi-directional lookup between ranks and values(for comparison)
declare -a Cards=(2 3 4 5 6 7 8 9 10 J Q K A)
declare -A Ranks
for rank in "${!Cards[@]}"; do
    Ranks[${Cards[$rank]}]=$rank
done

## parse the hand of poker into a "machine-readable" format, which is a space separated values in the structure below:
# <category> [suit] (ranks), where the list `ranks` are sorted in descending order, A is the biggest
# Following is some example structures:
# `straight 10`,            10 is the biggest rank in the straight
# `one_pair A 10 9 8`,      A is the pair, 10 9 8 are other cards
# `tow_pairs 3 2 8`,        3 and 2 are pairs, 8 is the kicker
# `three_of_a_kind 3 A 2`,  3 is the triplet, A and 2 are the remaining cards
# `full_house 3 4`,         3 is the triplet, 4 is the pair
# `four_of_a_kind 10 A`,    10 is the quad, A is the kicker
# `flush H 2 4 6 8 9`,      H is the suit, 2 4 6 8 9 are the cards
# `straight_flush S 10`,    S is the suit, 10 is the biggest rank in the straight
# `high_card 10 8 7 5 4`    cards in descending order
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

    # due to shell's dynamic scoping, the functions below can access the variables defined in current function
    flush ||
        three_of_a_kind ||
        full_house ||
        one_pair ||
        two_pairs ||
        four_of_a_kind ||
        straight ||
        straight_flush ||
        high_card
}

flush() {
    [[ -n $flush && -z $straight ]] && echo "flush $flush ${ranks[*]}"
}

three_of_a_kind() {
    [[ -n $triplet ]] && ((${#pairs[@]} == 0)) && {
        array::remove ranks "${triplet}"
        echo "three_of_a_kind ${triplet} ${ranks[*]}"
    }
}

full_house() {
    [[ -n $triplet ]] && ((${#pairs[@]} == 1)) && echo "full_house $triplet ${pairs[0]}"
}

one_pair() {
    ((${#pairs[@]} == 1)) && {
        array::remove ranks "${pairs[0]}"
        echo "one_pair ${pairs[0]} ${ranks[*]}"
    }
}

two_pairs() {
    ((${#pairs[@]} == 2)) && {
        array::remove ranks "[${pairs[0]}${pairs[1]}]"
        echo "two_pairs ${pairs[*]} ${ranks[*]}"
    }
}
four_of_a_kind() {
    [[ -n $quad ]] && {
        array::remove ranks "$quad"
        echo "four_of_a_kind $quad ${ranks[*]}"
    }
}

straight() {
    [[ -n $straight && -z $flush ]] && echo "straight $straight"
}

straight_flush() {
    [[ -n $straight && -n $flush ]] && echo "straight_flush $straight $flush"
}

high_card() {
    echo "high_card ${ranks[*]}"
}

ranks::compare() {
    local -a ranks1 ranks2
    read -ra ranks1 <<<"$1"
    read -ra ranks2 <<<"$2"
    local -a values1 values2
    for ((i = 0; i < ${#ranks1[@]}; i++)); do
        values1+=("${Ranks[${ranks1[$i]}]}")
        values2+=("${Ranks[${ranks2[$i]}]}")
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
    local -a cards
    read -ra cards <<<"$1"

    # grouping ranks
    for rank in "${cards[@]%?}"; do
        # __groups is a nameref of an associative array, `$` cannot be omitted
        #shellcheck disable=SC2004
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
