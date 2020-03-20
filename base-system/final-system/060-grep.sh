#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=060-grep
PKG_NAME=grep
TARBALL=grep-3.4.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --bindir=/bin
make
make install

fi

cleanup $DIRECTORY
log $NAME