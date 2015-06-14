#!/bin/sh -e
# Run this script from within the docker container.

BUCKET=heroku-buildpack-elm

echo "Uploading ${VERSION} to bucket ${BUCKET}"
set -x
aws s3 cp --recursive /app/bin/ s3://${BUCKET}/assets/${VERSION}/ --exclude "*" --include "elm*" --include "spas"
echo "done"

