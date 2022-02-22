#!/usr/bin/env bash

max=$1
shift
sum=0
for i; do
    for ((j = i; j < max; j += j)); do
        ((sum += j))
    done
done

echo $sum
