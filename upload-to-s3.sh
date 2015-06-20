#!/bin/sh -e
# Run this script from within the docker container.

BUCKET=heroku-buildpack-elm

# XXX: awscli is unable to read volume-mounted ~/.aws from within a docker container. So, we resort to this hack.
export AWS_ACCESS_KEY_ID="`grep access_key_id ~/.aws/credentials | cut -d= -f2 | xargs`"
export AWS_SECRET_ACCESS_KEY="`grep secret_access_key ~/.aws/credentials | cut -d= -f2 | xargs`"
export AWS_DEFAULT_REGION="`grep region ~/.aws/config | cut -d= -f2 | xargs`"

echo "Uploading elm ${ELM_VERSION}, spas ${SPAS_VERSION} and warp to bucket ${BUCKET}"
echo "Using AWS KEY: ${AWS_ACCESS_KEY_ID}"
set -x
aws s3 cp --recursive /app/bin/ s3://${BUCKET}/assets/warp/${WARP_VERSION}/ --exclude "*" --include "warp"
# TODO: don't upload all elm* binaries
aws s3 cp --recursive /app/bin/ s3://${BUCKET}/assets/elm/${ELM_VERSION}/ --exclude "*" \
    --include "elm" \
    --include "elm-package" \
    --include "elm-make"
aws s3 cp --recursive /app/bin/ s3://${BUCKET}/assets/spas/${SPAS_VERSION}/ --exclude "*" --include "spas"
echo "done"

