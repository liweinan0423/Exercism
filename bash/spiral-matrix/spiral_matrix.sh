#!/usr/bin/env bash

dir=east
width=$1

x=0 y=0

offsetX=0 offsetY=0

declare -a matrix
for ((i = 1; i <= $1 * $1; i++)); do
    matrix[$((y * $1 + x))]=$i
    case $dir in
    east)
        ((x += 1))
        if ((x - offsetX == width - 1)); then
            dir=south
            ((reset += 1))
        fi
        ;;
    south)
        ((y += 1))
        if ((y - offsetY == width - 1)); then
            dir=west
            ((reset += 1))
        fi
        ;;
    west)
        ((x -= 1))
        if ((x == offsetX)); then
            dir=north
            ((reset += 1))
        fi
        ;;
    north)
        ((y -= 1))
        if ((y == offsetY + 1)); then
            dir=east
            ((reset += 1))
        fi
        ;;
    esac
    if ((reset == 4)); then
        reset=0
        ((width -= 2))
        ((offsetX += 1))
        ((offsetY += 1))
    fi
done

for ((i = 0; i < ${#matrix[@]}; i += $1)); do
    echo "${matrix[@]:i:$1}"
done
