#!/bin/bash

set -e

SRC_ROOT=$(pwd)
WORKSPACE_DIR=$SRC_ROOT/workspace

CONTAINER_NAME=swift-armv7-sysroot
DISTRIUBTION=$1

case $DISTRIUBTION in
    # Not working yet- finding Threads issue
    #ubuntu:focal)
    #    INSTALL_DEPS_CMD=" \
    #       apt update && \
    #       apt install -y libc6-dev libgcc-9-dev libicu-dev libstdc++-9-dev libstdc++6 linux-libc-dev zlib1g-dev \
    #    "
    #    ;;
    # Not working yet- finding Threads issue
    #debian:bullseye)
    #    INSTALL_DEPS_CMD=" \
    #       apt update && \
    #       apt install -y libc6-dev libgcc-10-dev libicu-dev libstdc++-10-dev libstdc++6 linux-libc-dev zlib1g-dev \
    #    "
    #    ;;
    "ubuntu:jammy" | "debian:bookworm")
        INSTALL_DEPS_CMD=" \
           apt update && \
           apt install -y libc6-dev libgcc-12-dev libicu-dev libstdc++-12-dev libstdc++6 linux-libc-dev zlib1g-dev \
        "
        ;;
    "ubuntu:mantic" | "ubuntu:noble")
        INSTALL_DEPS_CMD=" \
           apt update && \
           apt install -y libc6-dev libgcc-13-dev libicu-dev libstdc++-13-dev libstdc++6 linux-libc-dev zlib1g-dev \
        "
        ;;
    *)
        echo "Unsupported distribution $DISTRIBUTION!"
        echo "If you'd like to support it, update this script to add the apt package list for it."
        ;;
esac

echo "Starting up qemu emulation"
docker run --privileged --rm tonistiigi/binfmt --install all

echo "Building $DISTRIUBTION distribution for sysroot"
docker rm --force $CONTAINER_NAME
docker run \
    --platform linux/arm/v7 \
    --name $CONTAINER_NAME \
    $DISTRIUBTION \
    /bin/bash -c "apt update && apt install -y $PACKAGE_LIST"

echo "Extracting sysroot folders"
rm -rf sysroot
mkdir -p sysroot/usr
docker cp $CONTAINER_NAME:/lib sysroot/lib
docker cp $CONTAINER_NAME:/usr/lib sysroot/usr/lib
docker cp $CONTAINER_NAME:/usr/include sysroot/usr/include

echo "Cleaning up"
docker rm $CONTAINER_NAME
