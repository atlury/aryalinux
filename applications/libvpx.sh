#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libvpx
URL=https://github.com/webmproject/libvpx/archive/v1.8.0/libvpx-1.8.0.tar.gz
DESCRIPTION="This package, from the WebM project, provides the reference implementations of the VP8 Codec, used in most current html5 video, and of the next-generation VP9 Codec."
VERSION=1.8.0

#REQ:yasm
#REQ:nasm
#REQ:which

cd $SOURCE_DIR

wget -nc https://github.com/webmproject/libvpx/archive/v1.8.0/libvpx-1.8.0.tar.gz

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

sed -i 's/cp -p/cp/' build/make/Makefile &&

mkdir libvpx-build &&
cd libvpx-build &&

../configure --prefix=/usr \
--enable-shared \
--disable-static &&
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
