#!/usr/bin/env bash
quotient=$1

factors=()

prime=2

while ((prime * prime <= quotient)); do

    if ((quotient % prime == 0)); then

        factors+=("$prime")

        ((quotient /= prime))

    else

        ((prime++))

    fi

done

((quotient > 1)) && factors+=("$quotient")

echo "${factors[*]}"
