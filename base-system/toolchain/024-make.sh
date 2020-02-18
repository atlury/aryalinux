#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=024-make

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=make-4.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/tools --without-guile
make
make install

fi

cleanup $DIRECTORY
log $NAME