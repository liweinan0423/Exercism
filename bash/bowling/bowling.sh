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

declare -a frame  # a temporary buffer to determine if a frame is complete while rolling
declare -i score  # total score
declare -i frames # total frames

# Pending bonus counter
## - for a strike/spare frame, push 2/1 into the queue.
## - Decrease the counter by 1 for each bonus roll.
## - Counter is deleted from the queue when it is 0.
## - The queue should be empty when the game is over
declare -a bonus=()

main() {
    local roll
    for roll; do
        game_is_not_over || die "Cannot roll after game is over"
        roll_is_not_negative "$roll" || die "Negative roll is invalid"
        roll_is_less_than_10 "$roll" || die "Pin count exceeds pins on the lane"
        valid_frame "$roll" || die "Pin count exceeds pins on the lane"
        calculate_score "$roll"
        handle_frame "$roll"
    done
    game_is_over || die "Score cannot be taken until the end of the game"
    echo "$score"
}

game_is_not_over() {
    ((frames < 10)) || ((${#bonus[@]} > 0))
}

game_is_over() {
    ! game_is_not_over
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
            bonus+=(2) # a strike gets 2 bonus rolls
            ((frames++))
            frame=()
        elif ((${#frame[@]} == 2)); then
            if ((frame[0] + frame[1] == 10)); then
                bonus+=(1) # a spare gets 1 bonus rolls
            fi
            ((frames++))
            frame=()
        fi
    fi
}

valid_frame() {
    ((${#frame[@]} == 0)) ||                      # frame is empty, any roll is valid
        ((frame[0] == 10 || frame[0] + $1 <= 10)) # if first roll is 10, next roll will be valid(this only happens in the bonus rolls at the end of the game); otherwise the two rolls cannot exceed 10
}

main "$@"
