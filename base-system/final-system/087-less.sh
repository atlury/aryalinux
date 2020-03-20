#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=087-less
PKG_NAME=less
TARBALL=less-551.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --sysconfdir=/etc
make
make install

fi

cleanup $DIRECTORY
log $NAME