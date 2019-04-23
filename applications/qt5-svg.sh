#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=qt5-svg
URL=http://archive.ubuntu.com/ubuntu/pool/main/q/qtsvg-opensource-src/qtsvg-opensource-src_5.6.1.orig.tar.xz
DESCRIPTION=""
VERSION=5.6.1

#REQ:qt5

cd $SOURCE_DIR

wget -nc $URL

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY

whoami > /tmp/currentuser

# BUILD COMMANDS START HERE

qmake &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
sudo make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
