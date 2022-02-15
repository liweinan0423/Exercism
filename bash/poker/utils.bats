#!/usr/bin/env bats
load bats-extra



@test "should parse flush" {
    run bash utils.sh test hand::parse "2S 4S 5S 6S 7S"
    assert_output "flush S 7 6 5 4 2"
}

@test "should parse one pair" {
    run bash utils.sh test hand::parse "2S 4H 6S 4D JH"
    assert_output "one_pair 4 J 6 2"
}