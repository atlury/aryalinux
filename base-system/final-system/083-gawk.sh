#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=083-gawk
PKG_NAME=gawk
TARBALL=gawk-5.0.1.tar.xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make
make install
mkdir -v /usr/share/doc/gawk-5.0.1
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.0.1

fi

cleanup $DIRECTORY
log $NAME