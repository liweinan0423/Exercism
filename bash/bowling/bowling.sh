#!/usr/bin/env bash

## Utilities ##
assert() {
    eval "$1" || die "$2"
}

die() {
    echo "$1"
    exit 1
}
###############

declare -a frame    # a temporary buffer to determine if a frame is complete while rolling
declare -i score    # total score
declare -i frames   # total frames
declare -a bonus=() # pending bonus points

main() {
    local n
    for n; do
        game_is_not_over || die "Cannot roll after game is over"
        roll_is_not_negative "$n" || die "Negative roll is invalid"
        roll_is_less_than_10 "$n" || die "Pin count exceeds pins on the lane"
        valid_frame "$n" || die "Pin count exceeds pins on the lane"
        calculate_score "$n"
        handle_frame "$n"
    done
    assert "((${#bonus[@]} == 0 && frames==10))" "Score cannot be taken until the end of the game"
    echo "$score"
}

game_is_not_over() {
    ((frames < 10)) || ((${#bonus[@]} > 0))
}

roll_is_not_negative() {
    (($1 >= 0))
}

roll_is_less_than_10() {
    (($1 <= 10))
}
calculate_score() {
    local n=$1
    if ((frames < 10)); then
        score+=$n
    fi
    for key in "${!bonus[@]}"; do
        if ((bonus[key] > 0)); then
            score+=$n
            ((bonus[key] -= 1))
        fi
        if ((bonus[key] == 0)); then
            unset "bonus[$key]"
        fi
    done
}

handle_frame() {
    local n=$1
    frame+=("$n")
    if ((frames < 10)); then
        if ((n == 10)); then
            bonus+=(2)
            ((frames++))
            frame=()
        elif ((${#frame[@]} == 2)); then
            if ((frame[0] + frame[1] == 10)); then
                bonus+=(1)
            fi
            ((frames++))
            frame=()
        fi
    fi
}

valid_frame() {
    local roll=$1
    if ((${#frame[@]} == 0)); then
        return 0
    elif ((frames < 10)); then
        if ((${#frame[@]} == 1)); then
            ((frame[0] + roll <= 10))
        fi
    else
        if ((${#frame[@]} == 1)); then
            ((frame[0] == 10 || frame[0] + roll <= 10))
        fi
    fi
}

main "$@"
