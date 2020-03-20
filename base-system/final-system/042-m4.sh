#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=042-m4
PKG_NAME=m4
TARBALL=m4-1.4.18.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME