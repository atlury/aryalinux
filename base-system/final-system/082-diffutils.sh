#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=082-diffutils
PKG_NAME=diffutils
TARBALL=diffutils-3.7.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME