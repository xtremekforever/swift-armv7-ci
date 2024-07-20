#!/bin/bash

set -e

SWIFT_TAG=${SWIFT_TAG:=swift-5.10.1-RELEASE}
SRC_ROOT=$(pwd)
WORKSPACE_DIR=$SRC_ROOT/workspace

# Checkout in separate workspace
if [ -d $WORKSPACE_DIR ]; then
    cd $WORKSPACE_DIR
else
    mkdir $WORKSPACE_DIR && cd $WORKSPACE_DIR
fi

# Clone Swift repo
if [ ! -d swift ]; then
echo "Checkout swift repo"
    git clone https://github.com/swiftlang/swift.git
fi

# Clone repos at SWIFT_TAG, skip cmake
echo "Clone repos"
cd swift
git am --abort || git stash
./utils/update-checkout --tag $SWIFT_TAG --clone --skip-repository cmake

# Apply Swift patch
export GIT_COMMITTER_NAME="Jesse L. Zamora"
export GIT_COMMITTER_EMAIL="xtremekforever@gmail.com"
echo "Apply patches"
git am $SRC_ROOT/patches/0001-Add-patches-buildbot-for-Swift-5.10-on-armv7.patch
