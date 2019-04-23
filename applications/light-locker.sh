#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=light-locker
URL=https://github.com/the-cavalry/light-locker/releases/download/v1.7.0/light-locker-1.7.0.tar.bz2
DESCRIPTION=""
VERSION=1.7.0

#REQ:gnome-common
#REQ:lightdm
#REQ:systemd
#REQ:upower

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

./configure --prefix=/usr &&
make
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
