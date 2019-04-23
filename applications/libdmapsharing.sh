#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libdmapsharing
URL=https://github.com/GNOME/libdmapsharing/archive/LIBDMAPSHARING_3_9_4.tar.gz
DESCRIPTION=""
VERSION=3.9.4


cd $SOURCE_DIR

wget -nc https://github.com/GNOME/libdmapsharing/archive/LIBDMAPSHARING_3_9_4.tar.gz

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

./autogen.sh --disable-tests --prefix=/usr &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
