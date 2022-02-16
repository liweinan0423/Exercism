#!/usr/bin/env bash

#shellcheck disable=SC2086,SC2046,SC2068

check() {
    set -- $(normalize $1) $(normalize $2) $(normalize $3)
    sides_should_be_positive $@ &&
        sides_should_form_triangle $@ &&
        determine_type $@ || echo none
}

sides_should_be_positive() {
    (($1 > 0 && $2 > 0 && $3 > 0))
}

sides_should_form_triangle() {
    (($1 + $2 > $3 && $2 + $3 > $1 && $1 + $3 > $2))
}

determine_type() {
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
normalize() {
    echo $((${1/./} * 10))
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
