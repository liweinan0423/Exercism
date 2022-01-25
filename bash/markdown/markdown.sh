#!/usr/bin/env bash
parse_bold() {
    while true; do
        orig=$line
        if [[ $line =~ ^(.+)__(.*) ]]; then
            post=${BASH_REMATCH[2]}
            pre=${BASH_REMATCH[1]}
            if [[ $pre =~ ^(.*)__(.+) ]]; then
                printf -v line "%s<strong>%s</strong>%s" "${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "$post"
            fi
        fi
        [ "$line" != "$orig" ] || break
    done
}

parse_italics() {
    while [[ $line == *_*?_* ]]; do
        one=${line#*_}
        two=${one#*_}
        if [[ ${#two} -lt ${#one} && ${#one} -lt ${#line} ]]; then
            line="${line%%_"$one"}<em>${one%%_"$two"}</em>$two"
        fi
    done
}

is_list_item() {
    grep '^\* ' <<<"$line" >/dev/null 2>&1
}
inside_list() {
    [[ "$inside_a_list" == yes ]]
}
start_list() {
    h="$h<ul>"
    inside_a_list=yes
}

list_append() {
    h="$h<li>${line#??}</li>"
}

end_list() {
    inside_a_list=no
}

list_end() {
    echo "</ul>"
}

parse_heading_or_paragraph() {
    if [[ $line =~ ^(#{1,6})\ +(.*) ]]; then
        HEAD=${BASH_REMATCH[2]}
        LEVEL=${BASH_REMATCH[1]}
        echo "<h${#LEVEL}>$HEAD</h${#LEVEL}>"
    else
        echo "<p>$line</p>"
    fi
}
transform_line() {
    parse_bold
    parse_italics
}

declare h
while IFS= read -r line; do
    transform_line
    if is_list_item; then
        inside_list || start_list
        list_append
    else
        inside_list && {
            h+=$(list_end)
            end_list
        }
        h+=$(parse_heading_or_paragraph)
    fi
done <"$1"

inside_list && {
    h+=$(list_end)
    end_list
}

echo "$h"
