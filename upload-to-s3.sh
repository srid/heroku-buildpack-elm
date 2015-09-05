#!/bin/sh -e
# Run this script from within the docker container.

BUCKET=heroku-buildpack-elm
S3UPLOAD="aws s3 sync --acl public-read"

# XXX: awscli is unable to read volume-mounted ~/.aws from within a docker container. So, we resort to this hack.
export AWS_ACCESS_KEY_ID="`grep access_key_id ~/.aws/credentials | cut -d= -f2 | xargs`"
export AWS_SECRET_ACCESS_KEY="`grep secret_access_key ~/.aws/credentials | cut -d= -f2 | xargs`"
export AWS_DEFAULT_REGION="`grep region ~/.aws/config | cut -d= -f2 | xargs`"

echo "Uploading elm ${ELM_VERSION} to bucket ${BUCKET}"
echo "What we have in /app/bin right now:"
ls -l /app/bin
set -x
${S3UPLOAD} /app/bin/ s3://${BUCKET}/assets/elm/${ELM_VERSION}/ --exclude "*" \
    --include "elm" \
    --include "elm-package" \
    --include "elm-make"

echo "done"
