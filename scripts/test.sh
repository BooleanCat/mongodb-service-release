#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

if [ "$DOCKER_ACTIVE" != "true" ]; then
  echo "Run ./scripts/docker-test.sh" >&2
  exit 1
fi

pushd "$PROJECT_ROOT" >/dev/null
  ./src/bash-utils/test.sh
  ./src/unit-tests/test.sh
popd >/dev/null
