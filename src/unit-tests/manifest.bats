#!/usr/bin/env bats

PROJECT_ROOT=../..

@test "manifest generation succeeds" {
  run bosh interpolate --vars-file "${PROJECT_ROOT}/manifest/vars-lite.yml" "${PROJECT_ROOT}/manifest/deployment.yml"

  [ "$status" -eq 0 ]
}
