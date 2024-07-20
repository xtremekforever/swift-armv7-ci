#!/bin/bash

set -e

SRC_ROOT=$(pwd)
WORKSPACE_DIR=$SRC_ROOT/workspace
SYSROOT_PATH=$SRC_ROOT/sysroot

INSTALL_DESTDIR=${INSTALL_DESTDIR:=$SRC_ROOT/install}
INSTALLABLE_PACKAGE=${INSTALLABLE_PACKAGE:=$SRC_ROOT/swift-armv7.tar.gz}
TOOLCHAIN_PATH=${TOOLCHAIN_PATH:=/usr/bin}

# Use sccache if available
SCCACHE_BINARY=`which sccache`
if [ $? -eq 0 ]; then
    SCCACHE="--sccache"
fi

cd $WORKSPACE_DIR
./swift/utils/build-script $SCCACHE --preset=buildbot_linux_crosscompile_armv7,stdlib,corelibs \
    install_destdir=$INSTALL_DESTDIR \
    installable_package=$INSTALLABLE_PACKAGE \
    sysroot=$SYSROOT_PATH \
    workspace_dir=$WORKSPACE_DIR \
    toolchain_path=$TOOLCHAIN_PATH
