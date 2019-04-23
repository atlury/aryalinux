#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst-plugins-base
URL=http://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz
DESCRIPTION=""
VERSION=0.10.36

#REQ:gstreamer
#REQ:pango
#REC:alsa-lib
#REC:libgudev
#REC:libogg
#REC:libtheora
#REC:libvorbis
#REC:x7lib
#OPT:gobject-introspection
#OPT:cdparanoia
#OPT:gtk3
#OPT:check
#OPT:valgrind
#OPT:gtk-doc
#OPT:python2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gst-plugins-base/0.10/gst-plugins-base-0.10.36.tar.xz

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
