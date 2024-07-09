#!/usr/bin/env bash
set -eou pipefail

apt install -y --no-install-recommends mold || true
LINKER=`which mold` && echo "export LINKER=$LINKER" >> /etc/dockerinit || true
