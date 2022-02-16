#!/usr/bin/env bash

(($2 == $3 && $3 == $4)) && type=equilateral
(($2 != $3 && $3 != $4)) && type=scalene

[[ $type == "$1" ]] && echo true || echo false
