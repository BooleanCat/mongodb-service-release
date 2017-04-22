# Deploy

## bosh-lite

Configure `.envrc` bosh envs or set them manually, example `.envrc`:

```shell
export BOSH_ENVIRONMENT=http://192.168.50.4:25555
export BOSH_CA_CERT=~/workspace/bosh-lite/ca/certs/ca.crt
export BOSH_CLIENT=admin
export BOSH_CLIENT_SECRET=admin
export BOSH_DEPLOYMENT=mongodb-service
```

Configure your bosh lite with the provided `cloud-config` (you will likely need to make changes to `manifest/vars-lite.yml` if you'd like to use your own `cloud-config`):

```shell
bosh upload-cloud-config manifest/cloud-config-lite.yml
```

Create and upload a bosh release:

```shell
bosh create-release
bosh upload-release
```

Deploy!

```shell
bosh deploy --vars-file manifest/vars-lite.yml manifest/deployment.yml
```

# Test

Tests are run in docker. Build the test image with:

```shell
docker build -t mongodb-service-release .
```

Then run tests with:

```shell
./scripts/docker-test.sh
```
