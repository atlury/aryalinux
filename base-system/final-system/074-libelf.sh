#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=074-libelf
PKG_NAME=libelf
TARBALL=elfutils-0.178.tar.bz2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --disable-debuginfod
make
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

fi

cleanup $DIRECTORY
log $NAME