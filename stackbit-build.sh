#!/usr/bin/env bash

set -e
set -o pipefail
set -v

curl -s -X POST https://api.stackbit.com/project/5dcdc7c76d59d0001b485b5a/webhook/build/pull > /dev/null
if [[ -z "${STACKBIT_API_KEY}" ]]; then
    echo "WARNING: No STACKBIT_API_KEY environment variable set, skipping stackbit-pull"
else
    npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5dcdc7c76d59d0001b485b5a 
fi
curl -s -X POST https://api.stackbit.com/project/5dcdc7c76d59d0001b485b5a/webhook/build/ssgbuild > /dev/null
jekyll build
./inject-netlify-identity-widget.js _site
curl -s -X POST https://api.stackbit.com/project/5dcdc7c76d59d0001b485b5a/webhook/build/publish > /dev/null
