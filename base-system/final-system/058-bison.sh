#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=058-bison
PKG_NAME=bison
TARBALL=bison-3.5.2.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.5.2
make
make install

fi

cleanup $DIRECTORY
log $NAME