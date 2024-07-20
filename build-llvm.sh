#!/bin/bash

set -e

SRC_ROOT=$(pwd)
WORKSPACE_DIR=$SRC_ROOT/workspace

# Use sccache if available
SCCACHE_BINARY=`which sccache`
if [ $? -eq 0 ]; then
    SCCACHE="--sccache"
fi

# Build llvm using cross-compile preset
cd $WORKSPACE_DIR
./swift/utils/build-script $SCCACHE --preset=buildbot_linux_crosscompile_armv7,llvm \
    workspace_dir=$WORKSPACE_DIR
