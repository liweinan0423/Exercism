#!/usr/bin/env bash

digits=${1//-/}
[[ ${digits} =~ ^[0-9]{9}[0-9X]$ ]] || { echo false && exit; }
for ((i = 0; i < ${#digits}; i++)); do
    case ${digits:i:1} in
    [0-9])
        ((sum += ${digits:i:1} * (10 - i)))
        ;;
    X)
        ((sum += 10))
        ;;
    *)
        echo false
        exit
        ;;
    esac
done
((sum % 11 == 0)) && echo true || echo false
