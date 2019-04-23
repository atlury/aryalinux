#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=clutter-gst
URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.27.tar.xz
DESCRIPTION="The Clutter Gst package contains an integration library for using GStreamer with Clutter. Its purpose is to implement the ClutterMedia interface using GStreamer."
VERSION=3.0.27

#REQ:clutter
#REQ:gst10-plugins-base
#REQ:libgudev
#REC:gobject-introspection
#REC:gst10-plugins-bad

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.27.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/3.0/clutter-gst-3.0.27.tar.xz

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

./configure --prefix=/usr &&
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
