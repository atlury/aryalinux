#!/bin/bash

set -e

. /sources/build-properties

for script in /sources/toolchain/*.sh
do

bash $script

done

echo "Creating toolchain backup"

tar -cJvf /sources/toolchain-$OS_VERSION-$(uname -m).tar.xz /tools
