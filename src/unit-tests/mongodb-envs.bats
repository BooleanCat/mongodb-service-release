#!/usr/bin/env bats

PROJECT_ROOT=../..

source "${PROJECT_ROOT}/jobs/mongodb/templates/envs"

@test "LOG_DIR is correct" {
  [ "$LOG_DIR" = "/var/vcap/sys/log/mongodb" ]
}

@test "DB_DIR is correct" {
  [ "$DB_DIR" = "/var/vcap/store/mongodb" ]
}

@test "PIDFILE_DIR is correct" {
  [ "$PIDFILE_DIR" = "/var/vcap/sys/run/mongodb" ]
}

@test "MONGOD_PATH is correct" {
  [ "$MONGOD_PATH" = "/var/vcap/packages/mongodb/bin/mongod" ]
}

@test "CONFIG_PATH is correct" {
  [ "$CONFIG_PATH" = "/var/vcap/jobs/mongodb/config/config.yml" ]
}

@test "UTILS_PATH is correct" {
  [ "$UTILS_PATH" = "/var/vcap/packages/bash-utils/bin/utils.sh" ]
}
