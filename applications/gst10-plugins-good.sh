#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst10-plugins-good
URL=https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz
DESCRIPTION="The GStreamer Good Plug-ins is a set of plug-ins considered by the GStreamer developers to have good quality code, correct functionality, and the preferred license (LGPL for the plug-in code, LGPL or LGPL-compatible for the supporting library). A wide range of video and audio decoders, encoders, and filters are included."
VERSION=1.14.4

#REQ:gst10-plugins-base
#REC:cairo
#REC:flac
#REC:lame
#REC:mpg123
#REC:mesa
#REC:gdk-pixbuf
#REC:libgudev
#REC:libjpeg
#REC:libpng
#REC:libsoup
#REC:libvpx
#REC:x7lib

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.14.4.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/gst-plugins-good-1.14.4-vpx_1.8-1.patch

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

patch -Np1 -i ../gst-plugins-good-1.14.4-vpx_1.8-1.patch &&
autoreconf -fi
./configure --prefix=/usr \
--with-package-name="GStreamer Good Plugins 1.14.4 BLFS" \
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
