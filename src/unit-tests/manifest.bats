#!/usr/bin/env bats

PROJECT_ROOT=../..

source "${PROJECT_ROOT}/jobs/mongodb/templates/envs"

@test "manifest generation succeeds" {
  run bosh interpolate --vars-file "${PROJECT_ROOT}/manifest/vars-lite.yml" "${PROJECT_ROOT}/manifest/deployment.yml"

  [ "$status" -eq 0 ]
}
