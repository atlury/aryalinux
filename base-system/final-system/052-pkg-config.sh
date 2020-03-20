#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=052-pkg-config
PKG_NAME=pkg-config
TARBALL=pkg-config-0.29.2.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2
make
make install

fi

cleanup $DIRECTORY
log $NAME