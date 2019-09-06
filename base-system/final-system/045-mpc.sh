#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=045-mpc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=mpc-1.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0
make
make html
make install
make install-html

fi

cleanup $DIRECTORY
log $NAME