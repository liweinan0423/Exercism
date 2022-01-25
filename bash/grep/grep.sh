#!/usr/bin/env bash

# flag functions
lineno() { false; }
filename() { false; }
invert() { false; }

main() {
    local OPTIND OPTARG # these 2 variable are assigned by `getopts`
    local pattern_fmt="%s"
    while getopts nilxv opt; do
        case $opt in
        n)
            lineno() { true; }
            ;;
        i)
            shopt -s nocasematch
            ;;
        l)
            filename() { true; }
            ;;
        x)
            pattern_fmt="^%s$"
            ;;
        v)
            invert() { true; }
            ;;
        *) ;;
        esac
    done
    shift $((OPTIND - 1))

    local pattern
    # shellcheck disable=SC2059
    printf -v pattern "$pattern_fmt" "$1"
    shift
    grep "$pattern" "$@"
}

grep() {
    local pattern=$1 prefix
    shift
    
    ## the in "$@" can be omitted
    # for file in "$@"; do
    for file; do
        if (($# > 1)); then
            prefix="$file"
        fi
        grep_file "$pattern" "$file" "$prefix"
    done
}

grep_file() {
    local pattern=$1 file=$2 prefix=$3

    local -i lineNumber=1
    # shellcheck disable=SC2094
    while read -r line; do
        if match "$line" "$pattern"; then
            print "$line" "$file" "$lineNumber" "$prefix" || break # print returns 1 if option -l is present
        fi
        # shellcheck disable=SC2015
        lineno && ((lineNumber++)) || :
    done <"$file"
}

match() {
    local line=$1 pattern=$2
    if invert; then
        if [[ ! $line =~ $pattern ]]; then
            return
        fi
    else
        if [[ $line =~ $pattern ]]; then
            return
        fi
    fi
    return 1 # not matched
}

print() {
    local line=$1 file=$2 idx=$3 prefix=$4
    local -a segments=()
    if filename; then
        echo "$file"
        return 1 # filename flag takes precedence over line flags(-i, -n)
    else
        [[ -n $prefix ]] && segments+=("$prefix")
        lineno && segments+=("$idx")
        segments+=("$line")
    fi
    local IFS=':'
    echo "${segments[*]}"
}

main "$@"
