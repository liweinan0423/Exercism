#!/usr/bin/env bash

max=$1
shift
sum=0
multiples=()
for i; do
    for ((j = i; j > 0 && j < max; j += i)); do
        if ! ((multiples[j])); then
            ((sum += j))
            multiples[$j]=1
        fi
    done
done

echo $sum
