#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-mpv
URL=https://github.com/celluloid-player/celluloid/releases/download/v0.16/gnome-mpv-0.16.tar.xz
DESCRIPTION="Gnome MPV is a video player frontend to the mpv backend"
VERSION=0.16

#REQ:mpv
#REQ:gnome-desktop-environment

cd $SOURCE_DIR

wget -nc https://github.com/celluloid-player/celluloid/releases/download/v0.16/gnome-mpv-0.16.tar.xz

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
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
