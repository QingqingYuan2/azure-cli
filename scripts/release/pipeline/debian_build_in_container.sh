#!/usr/bin/env bash

# Build APT package in an Azure Container Instances
# This script assumes the Azure CLI is installed and logged in.

set -ex

: ${CLI_VERSION:?"CLI_VERSION is not set"}
: ${DISTRO:?"DISTRO is not set"}
: ${DISTRO_BASE_IMAGE:?"DISTRO_BASE_IMAGE is not set"}

docker run --rm \
           -v "$BUILD_SOURCESDIRECTORY":/mnt/repo \
           -v "$BUILD_STAGINGDIRECTORY":/mnt/artifacts \
           -e OUTPUT_DIR=/mnt/artifacts \
           -e CLI_VERSION=$CLI_VERSION \
           -e CLI_VERSION_REVISION=1~$DISTRO \
           $DISTRO_BASE_IMAGE \
           /mnt/repo/scripts/release/debian/build.sh

ls -all $BUILD_STAGINGDIRECTORY
