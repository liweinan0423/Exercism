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
            LINE="${LINE%%_"$one"}<em>${one%%_"$two"}</em>$two"
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

list_start() {
    echo "<ul>"
}

list_append() {
    local LINE=$1
    echo "<li>${LINE#??}</li>"
}

end_list() {
    inside_a_list=no
}

list_end() {
    echo "</ul>"
}

parse_heading_or_paragraph() {
    local LINE=$1
    if [[ $LINE =~ ^(#{1,6})\ +(.*) ]]; then
        HEAD=${BASH_REMATCH[2]}
        LEVEL=${BASH_REMATCH[1]}
        echo "<h${#LEVEL}>$HEAD</h${#LEVEL}>"
    else
        echo "<p>$LINE</p>"
    fi
}
transform_line() {
    parse_bold
    parse_italics
}

process_line() {
    transform_line
    if is_list_item; then
        LINE=$(list_append "$LINE")
        inside_list || {
            start_list
            LINE=$(list_start)$LINE
        }
    else
        LINE=$(parse_heading_or_paragraph "$LINE")
        inside_list && {
            LINE=$(list_end)$LINE
            end_list
        }
    fi
}

declare h
while IFS= read -r LINE; do
    process_line
    h+=$LINE
done <"$1"

inside_list && {
    h+=$(list_end)
    end_list
}

echo "$h"
