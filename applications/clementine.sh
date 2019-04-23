#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=clementine
URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/2016.12/Clementine-qt5.tar.xz
DESCRIPTION="Clementine is a multiplatform music player. It is inspired by Amarok 1.4, focusing on a fast and easy-to-use interface for searching and playing your music."
VERSION=1.3.1

#REQ:audio-video-plugins
#REQ:protobuf
#REQ:libchromaprint
#REQ:libgpod
#REQ:libimobiledevice
#REQ:libmygpo-qt1
#REQ:libcrypto++
#REQ:libechonest
#REQ:libglew
#REQ:libsparsehash
#REQ:libmtp
#REQ:sqlite3
#REQ:liblastfm

cd $SOURCE_DIR

wget -nc $URL

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
