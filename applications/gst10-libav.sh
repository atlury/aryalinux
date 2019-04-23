#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst10-libav
URL=https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.4.tar.xz
DESCRIPTION="The GStreamer Libav package contains GStreamer plugins for Libav (a fork of FFmpeg)."
VERSION=1.14.4

#REQ:gst10-plugins-base
#REC:yasm

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.14.4.tar.xz

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

./configure --prefix=/usr \
--with-package-name="GStreamer Libav Plugins 1.14.4 BLFS" \
--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
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
