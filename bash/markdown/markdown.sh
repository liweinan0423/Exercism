#!/usr/bin/env bash

shopt -s extglob # enable extended pattern matching in case statements

declare LINE   # this global variable holds the content of current line
declare OUTPUT # buffer for HTML outputs

# state matchine variables
declare STATE PREV_STATE
declare LIST_STATE=closed

main() {

    while read -r LINE; do
        process_block_styles
    done <"$1"

    if [[ $LIST_STATE == open ]]; then
        close_list
    fi
    echo "$OUTPUT"
}

process_inline_styles() {
    parse_bold
    parse_italics
}

determine_state() {
    PREV_STATE=$STATE
    case $LINE in
    \#\#\#\#\#\#\#*) # only h1-h6 are allowed, others are parsed as regular paragraph
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
}

close_list() {
    if [[ $LIST_STATE == open ]]; then
        OUTPUT+="</ul>"
        LIST_STATE=closed
    fi
}

process_block_styles() {
    determine_state
    process_inline_styles
    if [[ $PREV_STATE == list && $STATE != list ]]; then
        close_list
    fi
    case $STATE in
    header)
        parse_header
        ;;
    paragraph)
        parse_paragraph
        ;;
    list)
        parse_list
        ;;
    *)
        determine_state
        process_block_styles
        ;;
    esac
}

parse_header() {
    if [[ $LINE =~ ^(\#+)\ +(.*) ]]; then
        local level=$((${#BASH_REMATCH[1]}))
        local content=${BASH_REMATCH[2]}
        OUTPUT+="<h$level>$content</h$level>"
    fi
}

parse_paragraph() {
    OUTPUT+="<p>$LINE</p>"
}

parse_list() {
    case $LIST_STATE in
    closed)
        OUTPUT+="<ul>"
        LIST_STATE=open
        parse_list
        ;;
    open)
        to_listitem
        OUTPUT+=$LINE
        ;;
    esac
}

parse_bold() {
    while true; do
        orig=$LINE
        if [[ $LINE =~ ^(.+)__(.*) ]]; then
            post=${BASH_REMATCH[2]}
            pre=${BASH_REMATCH[1]}
            if [[ $pre =~ ^(.*)__(.+) ]]; then
                printf -v LINE "%s<strong>%s</strong>%s" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "$post"
            fi
        fi
        [ "$LINE" != "$orig" ] || break
    done
}

parse_italics() {
    while [[ $LINE == *_*?_* ]]; do
        one=${LINE#*_}
        two=${one#*_}
        if [[ ${#two} -lt ${#one} && ${#one} -lt ${#LINE} ]]; then
            printf -v LINE "%s" "${LINE%%_"$one"}<em>${one%%_"$two"}</em>$two"
        fi
    done
}


to_listitem() {
    printf -v LINE "<li>%s</li>" "${LINE#??}"
}

main "$@"
