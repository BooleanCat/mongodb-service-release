#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "${DIR}" )"

pushd "${PROJECT_ROOT}/src/tests/bash" >/dev/null
  bats .
popd >/dev/null
