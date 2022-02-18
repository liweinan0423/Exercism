#!/usr/bin/env bash

declare -A dict=(
    [AUG]=Methionine
    [UUU]=Phenylalanine
    [UUC]=Phenylalanine
    [UUA]=Leucine
    [UUG]=Leucine
    [UCU]=Serine
    [UCC]=Serine
    [UCA]=Serine
    [UCG]=Serine
    [UAU]=Tyrosine
    [UAC]=Tyrosine
    [UGU]=Cysteine
    [UGC]=Cysteine
    [UGG]=Tryptophan
    [UAA]=STOP
    [UAG]=STOP
    [UGA]=STOP
)

declare -a proteins

translate() {
    echo "${dict[$1]}"
}

invalid() {
    echo "Invalid codon"
    exit 1
}

main() {
    local -a proteins

    local protein
    while read -rn3 rna; do
        protein=$(translate "$rna")
        [[ -n $protein ]] || invalid
        [[ $protein == STOP ]] && rna= && break
        proteins+=("$protein")
    done < <(echo -n "$1")

    [[ -z $rna ]] || invalid
    echo "${proteins[@]}"
}

main "$@"
