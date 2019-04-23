#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libjpeg
URL=https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.0.2.tar.gz
DESCRIPTION="libjpeg-turbo is a fork of the original IJG libjpeg which uses SIMD to accelerate baseline JPEG compression and decompression. libjpeg is a library that implements JPEG image encoding, decoding and transcoding."
VERSION=2.0.2

#REQ:cmake
#REQ:nasm
#REQ:yasm

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-2.0.2.tar.gz

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

mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=RELEASE \
-DENABLE_STATIC=FALSE \
-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libjpeg-turbo-2.0.2 \
-DCMAKE_INSTALL_DEFAULT_LIBDIR=lib \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -f /usr/lib/libjpeg.so*
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


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
