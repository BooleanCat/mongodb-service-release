#!/usr/bin/env bats

PROJECT_ROOT=${PROJECT_ROOT:-"../../.."}

source "${PROJECT_ROOT}/jobs/mongodb/templates/pre-start"

setup() {
  test_dir="$( mktemp -d )"
  [ "$( owner_and_group "$test_dir" )" = "root:root" ]
}

@test "LOG_DIR is correct" {
  [ "$LOG_DIR" = "/var/vcap/sys/log/mongodb" ]
}

@test "DB_DIR is correct" {
  [ "$DB_DIR" = "/var/vcap/store/mongodb" ]
}

@test "ensure_dir" {
  run ensure_dir "${test_dir}/foo" vcap:vcap

  [ "$status" -eq 0 ]
  [ "$( ls "$test_dir" )" = "foo" ]
  [ "$( owner_and_group "${test_dir}/foo" )" = "vcap:vcap" ]
}

@test "ensure_dir updates owner and group on existing dir" {
  run ensure_dir "$test_dir" vcap:vcap

  [ "$status" -eq 0 ]
  [ "$( owner_and_group "$test_dir" )" = "vcap:vcap" ]
}

owner_and_group() {
  local dir="$1"
  ls -ld "$dir" | awk '{print $3 ":" $4}'
}
