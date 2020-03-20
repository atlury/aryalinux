#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=046-mpfr
PKG_NAME=mpfr
TARBALL=mpfr-4.0.2.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2
make
make install

fi

cleanup $DIRECTORY
log $NAME