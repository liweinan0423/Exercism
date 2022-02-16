#!/usr/bin/env bash

#shellcheck disable=SC2086,SC2046

check() {
    set -- $(handle_float $1) $(handle_float $2) $(handle_float $3)
    (($1 > 0 && $2 > 0 && $3 > 0)) || {
        echo none
        return
    }
    (($1 + $2 > $3 && $2 + $3 > $1 && $1 + $3 > $2)) || {
        echo none
        return
    }

    local -i equals=0

    (($1 == $2)) && ((equals++))
    (($2 == $3)) && ((equals++))
    (($1 == $3)) && ((equals++))

    case $equals in
    2 | 3) echo equilateral ;;
    1) echo isosceles ;;
    0) echo scalene ;;
    esac
}

handle_float() {
    echo ${1/./}
}

main() {
    local expected=$1
    shift
    local answer
    answer=$(check $1 $2 $3)

    if
        case $expected in
        equilateral | scalene) [[ $answer == "$expected" ]] ;;
        isosceles)
            [[ $answer == @(isosceles|equilateral) ]]
            ;;

        *) false ;;
        esac
    then
        echo true
    else
        echo false
    fi

}

main "$@"
