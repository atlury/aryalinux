#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gwenview5
URL=http://download.kde.org/stable/applications/18.12.2/src/gwenview-18.12.2.tar.xz
DESCRIPTION="Gwenview is a fast and easy-to-use image viewer for KDE."
VERSION=18.12.2

#REQ:exiv2
#REQ:krameworks5
#REQ:lcms2
#REC:libkdcraw

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/applications/18.12.2/src/gwenview-18.12.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/gwenview-18.12.2-exiv2_0.27-1.patch

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

patch -Np1 -i ../gwenview-18.12.2-exiv2_0.27-1.patch
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DBUILD_TESTING=OFF \
-Wno-dev .. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
