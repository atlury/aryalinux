#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=004-glibc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=glibc-2.30.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

mkdir -v build32
pushd    build32
	
echo slibdir=/tools/lib32 > configparms
../configure                             \
	  --prefix=/tools                    \
	  --host=i686-lfs-linux-gnu          \
	  --build=$(../scripts/config.guess) \
	  --libdir=/tools/lib32              \
	  --enable-kernel=3.2                \
	  --enable-add-ons                   \
	  --with-headers=/tools/include      \
	  libc_cv_forced_unwind=yes          \
	  libc_cv_c_cleanup=yes              \
	  CC="$LFS_TGT-gcc -m32"             \
	  CXX="$LFS_TGT-g++ -m32"
make
make install

popd

mkdir -v build
cd       build
../configure                             \
      --prefix=/tools                    \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/tools/include
make
make install
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out

fi

cleanup $DIRECTORY
log $NAME