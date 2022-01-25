#!/usr/bin/env bash
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
inside_list() {
    [[ "$inside_a_list" == yes ]]
}
start_list() {
    inside_a_list=yes
}

to_listitem() {
    printf -v LINE "<li>%s</li>" "${LINE#??}"
}

end_list() {
    inside_a_list=no
}

list_end() {
    echo "</ul>"
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

process_styles() {
    parse_bold
    parse_italics
}

prepend_list_start() {
    printf -v LINE "<ul>%s" "$LINE"
}
append_list_end() {
    printf -v LINE "</ul>%s" "$LINE"
}
process_line() {
    if is_list_item; then
        to_listitem
        inside_list || {
            start_list
            prepend_list_start
        }
    else
        parse_heading_or_paragraph
        inside_list && {
            append_list_end
            end_list
        }
    fi
    process_styles
}

declare LINE   # this global variable holds the content of current line
declare OUTPUT # buffer for HTML outputs

while IFS= read -r LINE; do
    process_line
    OUTPUT+=$LINE
done <"$1"

inside_list && {
    OUTPUT+="</ul>"
    end_list
}

echo "$OUTPUT"
