#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Nettle package contains a low-level cryptographic library that is designed to fit easily in many contexts."
SECTION="postlfs"
VERSION=3.4
NAME="nettle"



cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/nettle/nettle-3.4.tar.gz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make
sudo make install &&
sudo chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
sudo install -v -m755 -d /usr/share/doc/nettle-3.4 &&
sudo install -v -m644 nettle.html /usr/share/doc/nettle-3.4


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
