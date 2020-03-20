#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=056-psmisc
PKG_NAME=psmisc
TARBALL=psmisc-23.3.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

fi

cleanup $DIRECTORY
log $NAME