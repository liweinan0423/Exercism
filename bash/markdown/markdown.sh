#!/usr/bin/env bash

# ================================================================================ #
# FIXME: This implementation doesn't support multi-line paragraphes, every line is #
# convered to a separate paragraph.                                                #
# ================================================================================ #

shopt -s extglob # enable extended pattern matching in case statements

declare LINE   # this global variable holds the content of current line
declare OUTPUT # buffer for HTML outputs

# state matchine variables
declare STATE PREV_STATE
declare LIST_STATE=closed

main() {
	exec <"$1"
	while IFS= read -r LINE; do
		process_line
	done
	process_line # process one more time in case there is no empty line before EOF
	echo "$OUTPUT"
}

process_line() {
	determine_state
	process_inline_styles

	case $STATE in
	end-of-list)
		close_list
		process_line
		;;
	header)
		parse_header
		;;
	paragraph)
		parse_paragraph
		;;
	list)
		parse_list
		;;
	empty) ;;
	*)
		determine_state
		process_line
		;;
	esac
}

determine_state() {
	PREV_STATE=$STATE
	case $LINE in
	"#######"*) # only h1-h6 are allowed, others are parsed as regular paragraph
		STATE=paragraph
		;;
	\#*)
		STATE=header
		;;
	[\*-]*)
		STATE=list
		;;
	*([[:space:]]))
		STATE=empty
		;;
	*)
		STATE=paragraph
		;;
	esac
	if [[ $PREV_STATE == list && $STATE != list ]]; then
		STATE=end-of-list
	fi
}

## below are actions for different states

close_list() {
	if [[ $LIST_STATE == open ]]; then
		OUTPUT+="</ul>"
		LIST_STATE=closed
	fi
}

open_list() {
	if [[ $LIST_STATE == closed ]]; then
		OUTPUT+="<ul>"
		LIST_STATE=open
	fi
}

parse_header() {
	local level content
	if [[ $LINE =~ ^(\#+)\ +(.*) ]]; then
		level=${#BASH_REMATCH[1]}
		content=${BASH_REMATCH[2]}
		OUTPUT+="<h$level>$content</h$level>"
	fi
}

parse_paragraph() {
	OUTPUT+="<p>$LINE</p>"
}

parse_list() {
	case $LIST_STATE in
	closed)
		open_list
		parse_list
		;;
	open)
		to_listitem
		OUTPUT+=$LINE
		;;
	*)
		LIST_STATE=closed
		parse_list
		;;
	esac
}

to_listitem() {
	printf -v LINE "<li>%s</li>" "${LINE#??}"
}

process_inline_styles() {
	parse_inline "__" "strong"
	parse_inline "_" "em"
}

parse_inline() {
	local mark=$1 tag=$2
	while true; do
		orig=$LINE
		if [[ $LINE =~ ^(.+)${mark}(.*) ]]; then
			post=${BASH_REMATCH[2]}
			pre=${BASH_REMATCH[1]}
			if [[ $pre =~ ^(.*)${mark}(.+) ]]; then
				printf -v LINE "%s<%s>%s</%s>%s" "${BASH_REMATCH[1]}" "${tag}" "${BASH_REMATCH[2]}" "${tag}" "$post"
			fi
		fi
		[ "$LINE" != "$orig" ] || break
	done
}

main "$@"
