#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gst-plugins-bad
URL=http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz
DESCRIPTION=""
VERSION=0.10.23

#REQ:gst-plugins-base
#REC:faac
#REC:libpng
#REC:libvpx
#REC:openssl10
#REC:xvid
#OPT:curl
#OPT:faad2
#OPT:jasper
#OPT:libass
#OPT:libmusicbrainz
#OPT:librsvg
#OPT:libsndfile
#OPT:libvdpau
#OPT:neon
#OPT:sdl
#OPT:soundtouch

cd $SOURCE_DIR

wget -nc http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-0.10.23.tar.xz

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
