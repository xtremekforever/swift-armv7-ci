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
./utils/update-checkout --tag $SWIFT_TAG --clone \
    --skip-repository cmake \
    --skip-repository cmark \
    --skip-repository curl \
    --skip-repository icu \
    --skip-repository indexstore-db \
    --skip-repository llbuild \
    --skip-repository libxml2 \
    --skip-repository sourcekit-lsp \
    --skip-repository swift-asn1 \
    --skip-repository swift-async-algorithms \
    --skip-repository swift-atomics \
    --skip-repository swift-argument-parser \
    --skip-repository swift-certificates \
    --skip-repository swift-collections \
    --skip-repository swift-crypto \
    --skip-repository swift-docc \
    --skip-repository swift-docc-render-artifact \
    --skip-repository swift-docc-symbolkit \
    --skip-repository swift-driver \
    --skip-repository swift-format \
    --skip-repository swift-installer-scripts \
    --skip-repository swift-integration-tests \
    --skip-repository swift-log \
    --skip-repository swift-llvm-bindings \
    --skip-repository swift-lmdb \
    --skip-repository swift-markdown \
    --skip-repository swift-nio \
    --skip-repository swift-nio-ssl \
    --skip-repository swift-numerics \
    --skip-repository swift-stress-tester \
    --skip-repository swift-syntax \
    --skip-repository swift-system \
    --skip-repository swift-tools-support-core \
    --skip-repository swift-xcode-playground-support \
    --skip-repository swiftpm \
    --skip-repository tensorflow-swift-apis \
    --skip-repository wasi-libc \
    --skip-repository wasmkit \
    --skip-repository yams \
    --skip-repository zlib \

# Apply Swift patch
export GIT_COMMITTER_NAME="Jesse L. Zamora"
export GIT_COMMITTER_EMAIL="xtremekforever@gmail.com"
echo "Apply patches"
git am $SRC_ROOT/patches/0001-Add-patches-buildbot-for-Swift-5.10-on-armv7.patch
