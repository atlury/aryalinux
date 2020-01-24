#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=005-gcc-libstdc++

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gcc-9.2.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

mkdir -v build32
pushd       build32
	
../libstdc++-v3/configure           \
	--host=i686-lfs-linux-gnu       \
	--prefix=/tools                 \
	--libdir=/tools/lib32           \
	--disable-multilib              \
	--disable-nls                   \
	--disable-libstdcxx-threads     \
	--disable-libstdcxx-pch         \
	--with-gxx-include-dir=/tools/$LFS_TGT/include/c++/9.2.0 \
	CC="$LFS_TGT-gcc -m32"          \
	CXX="$LFS_TGT-g++ -m32"
make
make install

popd

mkdir -v build
cd       build
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/9.2.0
make
make install

fi

cleanup $DIRECTORY
log $NAME