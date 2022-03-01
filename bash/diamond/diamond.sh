#!/usr/bin/env bash

declare -ra Alphabets=(A B C D E F G H I J K L M N O P Q R S T U V W X Y Z)
declare -A Indexes

for index in "${!Alphabets[@]}"; do
    Indexes[${Alphabets[$index]}]=$index
done

end=${Indexes[$1]}

declare -i i=0
declare top=true

while ((i > -1)); do
    printf "%*s" $((end - i)) ""
    printf "%s" "${Alphabets[$i]}"
    if ((i > 0)); then
        printf "%*s" $((2 * i - 1)) ""
        printf "%s" "${Alphabets[$i]}"
    fi
    printf "%*s\n" $((end - i)) ""
    ((i == end)) && top=false
    $top && ((i += 1))
    $top || ((i -= 1))
done
