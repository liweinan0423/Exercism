#!/usr/bin/env bash

declare -A atok # alpha to key
declare -A ktoa # key to alpha

for c in {a..z}; do
    ((idx++))
    atok[$c]=$idx
    ktoa[$idx]=$c
done

text=$1 key=$2
while IFS= read -r -n1 char; do
    case $char in
    [[:alpha:]])
        index=${atok[${char,}]}
        cipher=$((index + key))
        if ((cipher > 26)); then cipher=$((cipher % 26)); fi
        ;;& # ";;&" means to continue the match
    [[:lower:]])
        output+=${ktoa[$cipher]}
        ;;
    [[:upper:]])
        output+=${ktoa[$cipher]^}
        ;;
    *)
        output+=$char
        ;;
    esac
done < <(printf "%s" "$text")

echo "$output"
