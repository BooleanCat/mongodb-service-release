#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

shellcheck "${PROJECT_ROOT}/jobs/mongodb/templates/pre-start"

pushd "${PROJECT_ROOT}/src/tests/bash" >/dev/null
  bats .
popd >/dev/null
