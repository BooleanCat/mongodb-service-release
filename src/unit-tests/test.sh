#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$( dirname "$DIR" )" )"

pushd "$DIR" >/dev/null
  bats .
popd >/dev/null

shellcheck "${PROJECT_ROOT}/jobs/mongodb/templates/start"
shellcheck "${PROJECT_ROOT}/jobs/mongodb/templates/stop"
shellcheck "${PROJECT_ROOT}/jobs/mongodb/templates/envs"
