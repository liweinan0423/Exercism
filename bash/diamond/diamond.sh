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
    printf -v left "%*s%s%*s" $((end - i)) "" "${Alphabets[$i]}" $((i)) ""
    echo -n "$left"
    for ((j = ${#left} - 2; j >= 0; j--)); do
        printf "%s" "${left:j:1}"
    done
    echo
    ((i == end)) && top=false
    $top && ((i += 1))
    ! $top && ((i -= 1))
done
