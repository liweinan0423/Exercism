#!/usr/bin/env bash

declare -rA PAIRS=(
    [")"]='('
    ["}"]='{'
    ["]"]='['
)

match() {
    local expression=$1
    local stack=""

    local i=0 char
    for ((i = 0; i < ${#expression}; i++)); do
        char=${expression:$i:1}
        case $char in
        '(' | '[' | '{')
            # stack::push stack "$char"
            stack+=$char
            ;;
        ')' | ']' | '}')
            if [[ -z $stack || $stack != *"${PAIRS[$char]}" ]]; then
                return 1
            else
                stack="${stack%?}"
            fi
            ;;
        esac
    done
    ((${#stack} == 0))
}

# stolen from glennj's solution: since all elements in the stack is a single-char, we can use a string instead of an array as the stack

# stack::push() {
#     local -n ref=$1
#     local val=$2
#     ref+=("$val")
# }
# stack::pop() {
#     # shellcheck disable=SC2178
#     local -n ref=$1
#     local val=$2
#     unset "ref[-1]"
# }
# stack::peek() {
#     # shellcheck disable=SC2178
#     local -n ref=$1
#     [[ ${#ref[@]} -gt 0 ]] && echo "${ref[-1]}"
# }

main() {
    match "$@" && echo true || echo false
}

main "$@"
