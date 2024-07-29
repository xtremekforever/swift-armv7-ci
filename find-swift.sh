#!/bin/bash

set -e

# Find Swift executable in PATH
export SWIFT_EXE=$(which swift)
echo "Found Swift at $SWIFT_EXE"

# Determine TOOLCHAIN_PATH from Swift exe path
TOOLCHAIN_PATH="$(dirname $SWIFT_EXE)"
echo "Toolchain Path: $TOOLCHAIN_PATH"

# Print version as well
swift --version
