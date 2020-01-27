#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=055-libcap

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=libcap-2.30.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/install.*STACAPLIBNAME/d' libcap/Makefile
make lib=lib
make lib=lib install
chmod -v 755 /lib/libcap.so.2.30

fi

cleanup $DIRECTORY
log $NAME