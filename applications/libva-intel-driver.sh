#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libva-intel-driver
URL=https://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.7.3.tar.bz2
DESCRIPTION=""
VERSION=1.7.3

#REQ:mesa
#OPT:doxygen
#OPT:wayland

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/e4de7d482d444bcb77964cfc1fbcb0a67d1e31d5/libva-intel-driver-1.7.3-i965_drv_video.patch

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
