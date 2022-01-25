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

while IFS= read -r line; do
    parse_bold
    parse_italics

    if echo "$line" | grep '^\*' >/dev/null 2>&1; then
        if [[ "$inside_a_list" != yes ]]; then
            h="$h<ul>"
            inside_a_list=yes
        fi
        h="$h<li>${line#??}</li>"

    else
        if [[ $inside_a_list == yes ]]; then
            h="$h</ul>"
            inside_a_list=no
        fi

        n=$(expr "$line" : "#\{1,\}")
        if [[ $n -gt 0 ]] && [[ 7 -gt $n ]]; then
            HEAD=${line:n}
            while [[ $HEAD == " "* ]]; do HEAD=${HEAD# }; done
            h="$h<h$n>$HEAD</h$n>"

        else
            grep '_..*_' <<<"$line" >/dev/null &&
                line=$(echo "$line" | sed -E 's,_([^_]+)_,<em>\1</em>,g')
            h="$h<p>$line</p>"
        fi
    fi
done <"$1"

if [ X$inside_a_list = Xyes ]; then
    h="$h</ul>"
fi

echo "$h"
