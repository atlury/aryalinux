#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=055-sed
PKG_NAME=sed
TARBALL=sed-4.8.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in
./configure --prefix=/usr --bindir=/bin
make
make install

fi

cleanup $DIRECTORY
log $NAME