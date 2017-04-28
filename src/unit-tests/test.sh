#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$( dirname "$DIR" )" )"

pushd "$DIR" >/dev/null
  bats .
popd >/dev/null

pushd "${PROJECT_ROOT}/jobs/mongodb/templates" >/dev/null
  shellcheck start
  shellcheck stop
  shellcheck envs
popd >/dev/null
