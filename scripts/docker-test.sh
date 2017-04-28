#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

direnvs() {
  sed 's/^export //g' "${PROJECT_ROOT}/.envrc"
}

pushd "$PROJECT_ROOT" > /dev/null
  docker run \
    -v "${PROJECT_ROOT}:/home/test/mongodb-service-release" \
    -v "${BOSH_CA_CERT}:/tmp/ca.crt" \
    -e "BOSH_CA_CERT=/tmp/ca.crt" \
    --env-file <( "direnvs" ) \
    -w /home/test/mongodb-service-release \
    -i -t mongodb-service-release \
    scripts/test.sh
popd > /dev/null
