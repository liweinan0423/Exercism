#!/usr/bin/env bash

die() {
    echo "$1"
    exit 1
}

main() {
    local start=$1 end=$2
    [[ -z $end ]] && end=$start

    [[ $# -le 2 && -n $start && -n $end ]] || die "1 or 2 arguments expected"
    ((start >= end)) || die "Start must be greater than End"

    # verse "$start" "$end"
    state_machine "$start" "$end"
}

verse() {
    local -i start=$1 end=$2
    local line1 line2
    for ((i = start; i >= end; i--)); do
        line1="$(${i}_bottles) of beer on the wall, $(${i}_bottles) of beer."
        line2="$(do_sth), $($((i - 1))_bottles) of beer on the wall."
        line1=${line1^}
        line2=${line2^}
        echo "$line1"
        echo "$line2"
        echo
    done
}

command_not_found_handle() {
    if [[ $1 =~ (.*)_bottles ]]; then
        bottles "${BASH_REMATCH[1]}"
    else
        die "command not found: $1"
    fi
}

do_sth() {
    ((i > 0)) && echo "take $(it "i") down and pass it around" || echo "Go to the store and buy some more"
}
leftover() {
    local -i num=$(($1 > 0 ? $1 - 1 : 99))
    bottles $num
}

it() {
    (($1 == 1)) && echo it || echo one
}
bottles() {
    local output
    if (($1 == 0)); then
        output="no more bottles"
    elif (($1 == -1)); then
        output="99 bottles"
    elif (($1 == 1)); then
        output="1 bottle"
    elif (($1 > 1)); then
        output="$1 bottles"
    fi
    echo "$output"
}

state_machine() {
    local start=$1 end=$2 state=$start

    while ((state >= end)); do
        case $state in
        2)
            bottles="2 bottles"
            take="take one down"
            then="pass it around"
            bottles_left="1 bottle"
            ;;
        1)
            bottles="1 bottle"
            take="take it down"
            then="pass it around"
            bottles_left="no more bottles"
            ;;
        0)
            bottles="no more bottles"
            take="go to the store"
            then="buy some more"
            bottles_left="99 bottles"
            ;;
        *)
            bottles="$state bottles"
            take="take one down"
            then="pass it around"
            bottles_left="$((state - 1)) bottles"
            ;;
        esac

        echo "${bottles^} of beer on the wall, ${bottles} of beer."
        echo "${take^} and ${then}, ${bottles_left} of beer on the wall."
        echo
        state=$((state - 1))
    done

}

main "$@"
