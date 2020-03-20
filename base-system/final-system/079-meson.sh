#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=079-meson
PKG_NAME=meson
TARBALL=meson-0.53.2.tar.gz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


python3 setup.py build
python3 setup.py install --root=dest
cp -rv dest/* /

fi

cleanup $DIRECTORY
log $NAME