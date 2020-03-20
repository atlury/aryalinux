#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=094-patch
PKG_NAME=patch
TARBALL=patch-2.7.6.tar.xz

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