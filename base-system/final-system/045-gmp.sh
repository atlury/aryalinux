#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=045-gmp
PKG_NAME=gmp
TARBALL=gmp-6.2.0.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.0
make
make install

fi

cleanup $DIRECTORY
log $NAME