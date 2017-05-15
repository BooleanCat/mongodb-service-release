#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

direnvs() {
  sed 's/^export //g' "${PROJECT_ROOT}/.envrc"
}

mount_gateway_key_if_set() {
  if [ ! -z "$BOSH_GW_PRIVATE_KEY" ]; then
    echo -n "-v ${BOSH_GW_PRIVATE_KEY}:/tmp/pkey.pem -e BOSH_GW_PRIVATE_KEY=/tmp/pkey.pem"
  fi
}

pushd "$PROJECT_ROOT" > /dev/null
  docker run \
    -v "${PROJECT_ROOT}:/home/test/mongodb-service-release" \
    -v "${BOSH_CA_CERT}:/tmp/ca.crt" \
    $( mount_gateway_key_if_set ) \
    -e "BOSH_CA_CERT=/tmp/ca.crt" \
    --env-file <( "direnvs" ) \
    -w /home/test/mongodb-service-release \
    -i -t mongodb-service-release \
    scripts/test.sh
popd > /dev/null
