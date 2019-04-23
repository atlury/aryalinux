#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=transmission
URL=https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz
DESCRIPTION="Transmission is a cross-platform, open source BitTorrent client. This is useful for downloading large files (such as Linux ISOs) and reduces the need for the distributors to provide server bandwidth."
VERSION=2.94

#REQ:curl
#REQ:libevent
#REC:gtk3

cd $SOURCE_DIR

wget -nc https://raw.githubusercontent.com/transmission/transmission-releases/master/transmission-2.94.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
