#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=048-isl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=isl-0.22.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/isl-0.22
make
make install
install -vd /usr/share/doc/isl-0.22
install -m644 doc/{CodingStyle,manual.pdf,SubmittingPatches,user.pod} \
        /usr/share/doc/isl-0.22
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/libisl*gdb.py /usr/share/gdb/auto-load/usr/lib

fi

cleanup $DIRECTORY
log $NAME