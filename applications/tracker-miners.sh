#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=tracker-miners
URL=http://ftp.acc.umu.se/pub/gnome/sources/tracker-miners/2.2/tracker-miners-2.2.1.tar.xz
DESCRIPTION=""
VERSION=2.2.1

#REQ:libgrss

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/tracker-miners/2.2/tracker-miners-2.2.1.tar.xz

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

mkdir build
cd build
meson --prefix=/usr &&
ninja
sudo ninja install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
