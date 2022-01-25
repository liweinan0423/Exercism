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
    inside_a_list=yes
}

list_start() {
    echo "<ul>"
}

list_append() {
    local line=$1
    echo "<li>${line#??}</li>"
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

process_line() {
    transform_line
    if is_list_item; then
        line=$(list_append "$line")
        inside_list || {
            start_list
            line=$(list_start)$line
        }
    else
        line=$(parse_heading_or_paragraph "$line")
        inside_list && {
            line=$(list_end)$line
            end_list
        }
    fi
}

declare h
while IFS= read -r line; do
    process_line
    h+=$line
done <"$1"

inside_list && {
    h+=$(list_end)
    end_list
}

echo "$h"
