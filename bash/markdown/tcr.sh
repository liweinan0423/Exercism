#! /usr/bin/env bash

test() {
    bats ./*.bats
}
commit() { 
    git add .
    git commit -m "--wip--"
 }

reset() {
    git reset --hard HEAD
}


test && commit || reset
