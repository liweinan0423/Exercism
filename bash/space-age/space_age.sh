#!/usr/bin/env bash

# orbital periods in Earth years
declare -rA Orbital_periods=(
    [Mercury]=0.2408467
    [Venus]=0.61519726
    [Earth]=1.0
    [Mars]=1.8808158
    [Jupiter]=11.862615
    [Saturn]=29.447498
    [Uranus]=84.016846
    [Neptune]=164.79132
)


declare -ri Seconds_per_earch_year=31557600

planet=$1 age=$2

factor=${Orbital_periods[$planet]}
[[ -n $factor ]] || { echo "not a planet: $planet"; exit 1; }
printf "%.2f" "$(bc <<<"scale=3; $age / $Seconds_per_earch_year / $factor")"
