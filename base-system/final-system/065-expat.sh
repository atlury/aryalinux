#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=065-expat
PKG_NAME=expat
TARBALL=expat-2.2.9.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's|usr/bin/env |bin/|' run.sh.in
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.9
make
make install

fi

cleanup $DIRECTORY
log $NAME