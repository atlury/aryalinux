#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=069-intltool
PKG_NAME=intltool
TARBALL=intltool-0.51.0.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME