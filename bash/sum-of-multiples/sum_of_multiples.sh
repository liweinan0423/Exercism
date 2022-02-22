#!/usr/bin/env bash

max=$1
shift
sum=0
multiples=()
for base; do
    ((base > 0)) || continue
    for ((i = base; i < max; i += base)); do
        if ! ((multiples[i])); then
            ((sum += i))
            multiples[$i]=1
        fi
    done
done

echo $sum
