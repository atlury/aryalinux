#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=057-iana-etc
PKG_NAME=iana-etc
TARBALL=iana-etc-2.30.tar.bz2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make
make install

fi

cleanup $DIRECTORY
log $NAME