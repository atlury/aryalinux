#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=070-automake

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=automake-1.16.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.1
make
make install

fi

cleanup $DIRECTORY
log $NAME