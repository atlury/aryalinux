#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=018-file

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=file-5.38.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools
make
make install

fi

cleanup $DIRECTORY
log $NAME