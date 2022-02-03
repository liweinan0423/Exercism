#!/usr/bin/env bash

declare -ra OBJECTS=(
	"house that Jack built."
	"malt"
	"rat"
	"cat"
	"dog"
	"cow with the crumpled horn"
	"maiden all forlorn"
	"man all tattered and torn"
	"priest all shaven and shorn"
	"rooster that crowed in the morn"
	"farmer sowing his corn"
	"horse and the hound and the horn"
)

declare -ra VERBS=(
	""
	"lay in"
	"ate"
	"killed"
	"worried"
	"tossed"
	"milked"
	"kissed"
	"married"
	"woke"
	"kept"
	"belonged to"
)

rhyme() {
	printf "This is the %s\n" "${OBJECTS[$1]}"
	local -i i
	for ((i = $1; i > 0; i--)); do
		printf "that %s the %s\n" "${VERBS[$i]}" "${OBJECTS[i - 1]}"
	done
}

main() {

	local from=$1 to=$2
	# shellcheck disable=SC2015
	((from >= 1)) && ((from <= 12)) && ((to > 0)) && ((to <= 12)) && ((from <= to)) || {
		echo "invalid verse range"
		exit 1
	}
	local -i i
	for ((i = from - 1; i < to; i++)); do
		rhyme "$i"
		echo
	done

}

main "$@"
