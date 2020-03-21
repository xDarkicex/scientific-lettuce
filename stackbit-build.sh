#!/usr/bin/env bash

set -e
set -o pipefail
set -v

initialGitHash=$(git rev-list --max-parents=0 HEAD)
node ./studio-build.js $initialGitHash &

curl -s -X POST https://api.stackbit.com/project/5e768a0932ce0d00197f8013/webhook/build/pull > /dev/null
npx @stackbit/stackbit-pull --stackbit-pull-api-url=https://api.stackbit.com/pull/5e768a0932ce0d00197f8013
curl -s -X POST https://api.stackbit.com/project/5e768a0932ce0d00197f8013/webhook/build/ssgbuild > /dev/null
hugo
wait

curl -s -X POST https://api.stackbit.com/project/5e768a0932ce0d00197f8013/webhook/build/publish > /dev/null
echo "Stackbit-build.sh finished build"
