#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=001-binutils-pass1

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=binutils-2.32.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


mkdir -v build
cd       build
../configure --prefix=/tools            \
             --with-sysroot=$LFS        \
             --with-lib-path=/tools/lib:/tools/lib32 \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror

make
mkdir -p /tools/{lib32,lib} &&
ln -sv lib /tools/lib64
make install

fi

cleanup $DIRECTORY
log $NAME