#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=002-gcc-pass1

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gcc-9.2.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


tar -xf ../mpfr-4.0.2.tar.xz
mv -v mpfr-4.0.2 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.1.0.tar.gz
mv -v mpc-1.1.0 mpc
for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?\(x32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  touch $file.orig
done
sed -e "/^#define[[:blank:]]*STANDARD_STARTFILE_PREFIX_1/ s;\".*\";\"/tools/lib/\";" \
    -e "/^#define[[:blank:]]*STANDARD_STARTFILE_PREFIX_2/ s;\".*\";\"\";" \
    -i gcc/gcc.c
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac
mkdir -v build
cd       build
mloptions="--disable-multilib"
../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=/tools                                \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --with-local-prefix=/tools                     \
    --with-native-system-header-dir=/tools/include \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++                       \
    $mloptions
make
make install

fi

cleanup $DIRECTORY
log $NAME