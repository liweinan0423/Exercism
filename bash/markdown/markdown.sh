#!/usr/bin/env bash
declare LINE   # this global variable holds the content of current line
declare OUTPUT # buffer for HTML outputs

main() {

    while read -r LINE; do
        process_block_styles
    done <"$1"
    if [[ $list_state == open ]]; then
        close_list
    fi
    echo "$OUTPUT"
}

process_line() {
    process_inline_styles
    process_block_styles
}

process_inline_styles() {
    parse_bold
    parse_italics
}

declare block_state prev_state
declare list_state=closed
shopt -s extglob
determine_state() {
    prev_state=$block_state
    case $LINE in
    \#\#\#\#\#\#\#*) # only h1-h6 are allowed, others are parsed as regular paragraph
        block_state=paragraph
        ;;
    \#*)
        block_state=header
        ;;
    [\*-]*)
        block_state=list
        ;;
    *([[:space:]]))
        block_state=empty
        ;;
    *)
        block_state=paragraph
        ;;
    esac
}

close_list() {
    if [[ $list_state == open ]]; then
        OUTPUT+="</ul>"
        list_state=closed
    fi
}

process_block_styles() {
    determine_state
    process_inline_styles
    if [[ $prev_state == list && $block_state != list ]]; then
        close_list
    fi
    case $block_state in
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
    case $list_state in
    closed)
        OUTPUT+="<ul>"
        list_state=open
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

is_list_item() {
    grep '^\* ' <<<"$LINE" >/dev/null 2>&1
}

to_listitem() {
    printf -v LINE "<li>%s</li>" "${LINE#??}"
}

inside_list() {
    [[ "$inside_a_list" == yes ]]
}

start_list() {
    inside_a_list=yes
}

prepend_list_start() {
    printf -v LINE "<ul>%s" "$LINE"
}

prepend_list_end() {
    printf -v LINE "</ul>%s" "$LINE"
}

parse_heading_or_paragraph() {
    if [[ $LINE =~ ^(#{1,6})\ +(.*) ]]; then
        HEAD=${BASH_REMATCH[2]}
        LEVEL=${BASH_REMATCH[1]}
        printf -v LINE "%s" "<h${#LEVEL}>$HEAD</h${#LEVEL}>"
    else
        printf -v LINE "%s" "<p>$LINE</p>"
    fi
}

end_list() {
    inside_a_list=no
}

main "$@"
