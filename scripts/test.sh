#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

"${PROJECT_ROOT}/src/bash-utils/test.sh"
"${PROJECT_ROOT}/src/unit-tests/test.sh"
