#!/usr/bin/env bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$DIR" )"

pushd "$PROJECT_ROOT" > /dev/null
  docker run \
    -v "${PROJECT_ROOT}:/home/test/mongodb-service-release" \
    -v "${BOSH_CA_CERT}:/tmp/ca.crt" \
    -w /home/test/mongodb-service-release \
    -e "BOSH_DEPLOYMENT=${BOSH_DEPLOYMENT}" \
    -e "BOSH_ENVIRONMENT=${BOSH_ENVIRONMENT}" \
    -e "BOSH_CA_CERT=/tmp/ca.crt" \
    -e "BOSH_CLIENT=${BOSH_CLIENT}" \
    -e "BOSH_CLIENT_SECRET=${BOSH_CLIENT_SECRET}" \
    -i -t mongodb-service-release \
    scripts/test.sh
popd > /dev/null
