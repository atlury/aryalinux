#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=073-gettext
PKG_NAME=gettext
TARBALL=gettext-0.20.1.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.20.1
make
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

fi

cleanup $DIRECTORY
log $NAME