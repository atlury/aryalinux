#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gstreamer10
URL=https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.4.tar.xz
DESCRIPTION="gstreamer is a streaming media framework that enables applications to share a common set of plugins for things like video encoding and decoding, audio encoding and decoding, audio and video filters, audio visualisation, web streaming and anything else that streams in real-time or otherwise. This package only provides base functionality and libraries. You may need at least <a class=\xref\ href=\gst10-plugins-base.html\  title=\gst-plugins-base-1.14.1\>gst-plugins-base-1.14.1</a> and one of Good, Bad, Ugly or Libav plugins."
VERSION=1.14.4

#REQ:glib2
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc https://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.14.4.tar.xz

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
--with-package-name="GStreamer 1.14.4 BLFS" \
--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/" &&
make
rm -rf /usr/bin/gst-* /usr/{lib,libexec}/gstreamer-1.0

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
