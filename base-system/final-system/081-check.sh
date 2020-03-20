#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=081-check
PKG_NAME=check
TARBALL=check-0.14.0.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make docdir=/usr/share/doc/check-0.14.0 install &&
sed -i '1 s/tools/usr/' /usr/bin/checkmk

fi

cleanup $DIRECTORY
log $NAME