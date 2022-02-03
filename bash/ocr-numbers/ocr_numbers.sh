#!/usr/bin/env bash

ONE+=("   "); TWO+=(" _ "); THREE+=(" _ "); FOUR+=("   "); FIVE+=(" _ "); SIX+=(" _ "); SEVEN+=(" _ "); EIGHT+=(" _ "); NINE+=(" _ "); ZERO+=(" _ ");
ONE+=("  |"); TWO+=(" _|"); THREE+=(" _|"); FOUR+=("|_|"); FIVE+=("|_ "); SIX+=("|_ "); SEVEN+=("  |"); EIGHT+=("|_|"); NINE+=("|_|"); ZERO+=("| |");
ONE+=("  |"); TWO+=("|_ "); THREE+=(" _|"); FOUR+=("  |"); FIVE+=(" _|"); SIX+=("|_|"); SEVEN+=("  |"); EIGHT+=("|_|"); NINE+=(" _|"); ZERO+=("|_|");
ONE+=("   "); TWO+=("   "); THREE+=("   "); FOUR+=("   "); FIVE+=("   "); SIX+=("   "); SEVEN+=("   "); EIGHT+=("   "); NINE+=("   "); ZERO+=("   ");

die() {
	echo "$1"
	exit 1
}

run() {
	local -i nCols
	local -i nLines
	local -a cLines # this array stroes a single lines of numbers as a single element(join the 4 lines into one line)
	local cLineBuffer="" # concatenate every 4 lines together and append into (cLines)

	while IFS= read -r line && [[ -n $line ]]; do
		((nLines++))
		if ((nCols != 0 && nCols != ${#line})); then
			die "Inconsistent number of columns in line $nLines"
		fi
		nCols=${#line}
		cLineBuffer+="$line"
		if ((nLines % 4 == 0)); then
			cLines+=("$cLineBuffer")
			cLineBuffer=''
		fi
	done

	((nLines % 4 == 0)) || die "Number of input lines is not a multiple of four"
	((nCols % 3 == 0)) || die "Number of input columns is not a multiple of three"

	local -a outputs
	for cLine in "${cLines[@]}"; do
		outputs+=("$(scanLine 4 "$nCols" "$cLine")")
	done
	IFS=,
	echo "${outputs[*]}"
}

scanLine() {
	local nLines=$1 nCols=$2 cLineBuffer=$3
	local -a blocks
	for ((j = 0; j < nCols / 3; j++)); do
		for ((i = 0; i < nLines; i++)); do
			index=$((i * nCols + j * 3))
			blocks+=("${cLineBuffer:$index:3}")
		done
	done
	for ((i = 0; i < ${#blocks[@]}; i += 4)); do
		ocr "${blocks[@]:i:4}"
	done
}

ocr() {
	local IFS=
	case "$1$2$3$4" in
		"${ONE[*]}"   ) echo -n 1;;
		"${TWO[*]}"   ) echo -n 2;;
		"${THREE[*]}" ) echo -n 3;;
		"${FOUR[*]}"  ) echo -n 4;;
		"${FIVE[*]}"  ) echo -n 5;;
		"${SIX[*]}"   ) echo -n 6;;
		"${SEVEN[*]}" ) echo -n 7;;
		"${EIGHT[*]}" ) echo -n 8;;
		"${NINE[*]}"  ) echo -n 9;;
		"${ZERO[*]}"  ) echo -n 0;;
		*) echo -n ?;;
	esac
}

main() {
	if [[ -t 0 ]]; then
		exec 0<<<""
	fi
	run
}

main "$@"
