#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst-plugins-ugly
URL=http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz
DESCRIPTION=""
VERSION=0.10.19

#REQ:gst-plugins-base
#REC:lame
#REC:libdvdnav
#REC:libdvdread
#OPT:liba52
#OPT:libcdio
#OPT:libmad
#OPT:libmpeg2
#OPT:x264
#OPT:gtk-doc
#OPT:python2

cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-plugins-ugly-0.10.19-libcdio_fixes-1.patch
wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-ugly/gst-plugins-ugly-0.10.19.tar.xz

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
