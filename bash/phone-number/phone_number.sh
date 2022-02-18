#!/usr/bin/env bash

declare number=$1

number=${number//[\(\)\-\+\.[:space:]]/}

if [[ $number =~ ^1?[2-9][0-9]{2}[2-9][0-9]{6}$ ]]; then
    echo "${number#1}"
else
    echo "Invalid number.  [1]NXX-NXX-XXXX N=2-9, X=0-9"
    exit 1
fi
