#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=064-gperf
PKG_NAME=gperf
TARBALL=gperf-3.1.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1
make
make install

fi

cleanup $DIRECTORY
log $NAME