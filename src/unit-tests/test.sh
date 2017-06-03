#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$( dirname "$DIR" )" )"

pushd "$DIR" >/dev/null
  bats .
popd >/dev/null

pushd "${PROJECT_ROOT}/jobs/mongodb/templates" >/dev/null
  shellcheck -e 1091 pre-start
  shellcheck -e 1091 start
  shellcheck -e 1091 stop
  shellcheck -e 1091 envs
popd >/dev/null
