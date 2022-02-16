#!/usr/bin/env bash

(($2 == $3 && $3 == $4)) && type=equilateral

[[ $type == "$1" ]] && echo true || echo false
