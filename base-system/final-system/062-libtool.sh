#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=062-libtool
PKG_NAME=libtool
TARBALL=libtool-2.4.6.tar.xz

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