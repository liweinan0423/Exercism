#!/usr/bin/env bash

readonly accurancy=0
sqrt() {
    local approx=1
    while (($(bc -l <<<"d=$1-$approx^2; if (d >= 0) d>$accurancy else -d > $accurancy"))); do
        approx=$(bc -l <<<"($approx+$1/$approx)/2")
    done

    printf "%.0f" "$approx"
}

sqrt "$@"
