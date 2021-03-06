#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="mate-user-share"
DESCRIPTION="User level public file sharing via WebDAV or ObexFTP"
VERSION=1.20.0

cd $SOURCE_DIR

URL="http://pub.mate-desktop.org/releases/1.20/mate-user-share-1.20.0.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static --with-gtk=3.0 &&
make "-j`nproc`"

sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
