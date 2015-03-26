#!/usr/bin/env bats

@test "convert binary is found in PATH" {
  run which convert
  [ "$status" -eq 0 ]
}