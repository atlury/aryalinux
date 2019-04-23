#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=ssr
URL=https://github.com/MaartenBaert/ssr/archive/0.3.11.tar.gz
DESCRIPTION=""
VERSION=0.3.11

#REQ:qt5
#REQ:jack2
#REQ:ffmpeg
#REQ:pulseaudio

cd $SOURCE_DIR

wget -nc https://github.com/MaartenBaert/ssr/archive/0.3.11.tar.gz

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

mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DWITH_QT5=1 -DWITH_PULSEAUDIO=1 -DWITH_JACK=1 .. &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
