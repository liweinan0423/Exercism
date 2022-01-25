#!/usr/bin/env bash

dart() {
	[[ $1 == +([-[:digit:].]) && $2 == +([-[:digit:].]) ]] || {
		echo "Usage: ${0##*/} <x> <y>"
		exit 1
	}

	local x=$1 y=$2
	local ten five one
	{
		read -r ten
		read -r five
		read -r one
	} < <(
		bc -l <<-SCRIPT
			r = sqrt($x^2 + $y^2)
			r <= 1
			r <= 5
			r <= 10
		SCRIPT
	)
	case "$ten$five$one" in
	1??) echo 10 ;;
	01?) echo 5 ;;
	001) echo 1 ;;
	*) echo 0 ;;
	esac
}

main() {
	dart "$@"
}

main "$@"
