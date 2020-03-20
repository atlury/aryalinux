#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=096-tar
PKG_NAME=tar
TARBALL=tar-1.32.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.32

fi

cleanup $DIRECTORY
log $NAME