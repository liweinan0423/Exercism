#!/usr/bin/env bash

gs=1000000000
oneday=$((24 * 60 * 60))

days_per_month() {
    case $(($1)) in
    2) leap_year "$year" && echo 29 || echo 28 ;;
    1 | 3 | 5 | 7 | 8 | 10 | 12) echo 31 ;;
    *) echo 30 ;;
    esac
}

leap_year() {
    (($1 % 400 == 0 || ($1 % 100 != 0 && $1 % 4 == 0)))
}

main() {
    if [[ $1 =~ ^([0-9]{4})-([0-9]{2})-([0-9]{2})(T([0-9]{2}):([0-9]{2}):([0-9]{2}))?$ ]]; then
        year=${BASH_REMATCH[1]}
        month=${BASH_REMATCH[2]}
        day=${BASH_REMATCH[3]}
        hour=${BASH_REMATCH[5]}
        minute=${BASH_REMATCH[6]}
        second=${BASH_REMATCH[7]}
    fi
    ((gs -= ($(days_per_month "$month") - day + 1) * oneday))
    day=1
    ((month++))
    if ((month == 13)); then
        ((year++))
        month=1
    fi

    break=false
    while ((gs > 0)) && ! $break; do
        while ((month < 13)) && ! $break; do
            ((gs -= $(days_per_month "$month") * oneday))
            if ((gs > 0)); then
                ((month++))
            else
                ((gs += $(days_per_month "$month") * oneday))
                break=true
            fi
        done

        if ((month == 13)); then
            ((year++))
            month=1
        fi
    done
    ((second += gs % 60))
    ((minute += (gs / 60) % 60 + second / 60))
    ((hour += (gs / 60 / 60) % 24 + minute / 60))
    ((day += gs / oneday + hour / 24))
    if ((second >= 60)); then
        ((second -= 60))
    fi
    if ((minute >= 60)); then
        ((minute -= 60))
    fi
    if ((hour >= 24)); then
        ((hour -= 24))
    fi

    printf "%s-%02s-%02sT%02s:%02s:%02s\n" "$year" "$month" "$day" "$hour" "$minute" "$second"
}

main "$@"
