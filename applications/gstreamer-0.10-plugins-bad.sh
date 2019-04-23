#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gstreamer-0.10-plugins-bad
URL=http://archive.ubuntu.com/ubuntu/pool/universe/g/gst-plugins-bad0.10/gst-plugins-bad0.10_0.10.23.orig.tar.bz2
DESCRIPTION=""
VERSION=0.10.23

#REQ:gstreamer-0.10

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://raw.githubusercontent.com/openembedded/meta-openembedded/master/meta-multimedia/recipes-multimedia/gstreamer-0.10/gst-plugins-bad/buffer-overflow-mp4.patch
wget -nc https://raw.githubusercontent.com/maximeh/buildroot/master/package/gstreamer/gst-plugins-bad/0003-drop-buggy-libvpx-legacy-handling.patch

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
