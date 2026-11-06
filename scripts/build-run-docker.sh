#!/bin/bash

set -exu -o pipefail

cd "$(dirname "$0")/.."

export IMG=web-platform-lab
export PORT=8080
export "APP_TITLE=Hello ${USER}@$(hostname -s)"!
export "APP_DESCRIPTION=This is the <code>web-platform-lab</code> app running in a Docker container on <samp>$(uname -a)</samp>"

time docker buildx build --load -t $IMG .
docker run --rm -it -e APP_TITLE -e APP_DESCRIPTION -e PORT -p $PORT:$PORT $IMG
