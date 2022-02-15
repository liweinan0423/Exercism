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

@test "should parse two pairs" {
    run bash utils.sh test hand::parse "4S 5H 4C 8C 5C"
    assert_output "two_pairs 5 4 8"
}

@test "should parse three of a kind" {
    run bash utils.sh test hand::parse "4S 5H 4C 8S 4H"
    assert_output "three_of_a_kind 4 8 5"
}

@test "should parse full house" {
    run bash utils.sh test hand::parse "4S 5H 4C 5D 4H"
    assert_output "full_house 4 5"
}

@test "should parse four of a kind" {
    run bash utils.sh test hand::parse "3S 3H 2S 3D 3C"
    assert_output "four_of_a_kind 3 2"
}
