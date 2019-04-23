#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst-ffmpeg
URL=http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2
DESCRIPTION=""
VERSION=0.10.13

#REQ:gst-plugins-base
#REQ:yasm

cd $SOURCE_DIR

wget -nc http://www.linuxfromscratch.org/patches/blfs/systemd/gst-ffmpeg-0.10.13-gcc-4.7-1.patch
wget -nc http://gstreamer.freedesktop.org/src/gst-ffmpeg/gst-ffmpeg-0.10.13.tar.bz2

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
