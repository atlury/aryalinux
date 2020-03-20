#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=075-libffi
PKG_NAME=libffi
TARBALL=libffi-3.3.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --disable-static --with-gcc-arch=x86-64
make
make install

fi

cleanup $DIRECTORY
log $NAME