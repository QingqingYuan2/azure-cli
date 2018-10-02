#!/usr/bin/env bash

# Build APT package in an Azure Container Instances
# This script assumes the Azure CLI is installed and logged in.

set -ex

CLI_VERSION=$1
DISTRO=$2
DISTRO_BASE_IMAGE=$3
# export AZURE_STORAGE_ACCOUNT=$4

: ${CLI_VERSION:?"CLI_VERSION is not set"}
: ${DISTRO:?"DISTRO is not set"}
: ${DISTRO_BASE_IMAGE:?"DISTRO_BASE_IMAGE is not set"}
# : ${AZURE_STORAGE_ACCOUNT:?"STORAGE_NAME is not set"}

RG_NAME="clibuild$BUILD_BUILDNUMBER"
LOCATION=centralus
SHARE_NAME=$BUILD_BUILDNUMBER

# STORAGE_ACCOUNT_RG=`az storage account list --query "[?name=='$AZURE_STORAGE_ACCOUNT'].resourceGroup" -otsv`
# export AZURE_STORAGE_KEY=$(az storage account keys list -g $STORAGE_ACCOUNT_RG -n $AZURE_STORAGE_ACCOUNT --query "[1].value" -otsv)

# az storage file batch-download 

docker run --rm \
           -v `pwd`:/mnt/repo \
           -v "$BUILD_STAGINGDIRECTORY":/mnt/artifacts \
           -e OUTPUT_DIR=/mnt/artifacts \
           -e CLI_VERSION=$CLI_VERSION \
           -e CLI_VERSION_REVISION=1~$DISTRO \
           $DISTRO_BASE_IMAGE \
           /mnt/repo/scripts/release/debian/build.sh

ls -all $BUILD_STAGINGDIRECTORY

# az container create -g $RG_NAME -n ${DISTRO}-build -l $LOCATION --restart-policy Never \
#                     --image $DISTRO_BASE_IMAGE \
#                     --gitrepo-mount-path /mnt/repo \
#                     --gitrepo-url $BUILD_REPOSITORY_URI \
#                     --gitrepo-revision $BUILD_SOURCEBRANCHNAME \
#                     --azure-file-volume-account-name $STORAGE_NAME \
#                     --azure-file-volume-account-key $STORAGE_KEY \
#                     --azure-file-volume-mount-path /mnt/artifacts \
#                     --azure-file-volume-share-name $SHARE_NAME \
#                     -e OUTPUT_DIR=/mnt/artifacts CLI_VERSION=$CLI_VERSION CLI_VERSION_REVISION=1~$DISTRO \
#                     --command-line "/mnt/repo/scripts/release/debian/build.sh"
