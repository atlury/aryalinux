#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gstreamer-0.10-ffmpeg
URL=http://archive.ubuntu.com/ubuntu/pool/universe/g/gstreamer0.10-ffmpeg/gstreamer0.10-ffmpeg_0.10.13.orig.tar.bz2
DESCRIPTION=""
VERSION=0.10.13

#REQ:gstreamer-0.10

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-ffmpeg/0001-gcc47.patch
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-ffmpeg/0002-arm-avoid-using-the-movw-instruction.patch

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
