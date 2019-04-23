#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=appstream-glib
URL=https://people.freedesktop.org/~hughsient/appstream-glib/releases/appstream-glib-0.7.8.tar.xz
DESCRIPTION="appstream-glib"
VERSION=0.7.8

#REQ:yaml
#REQ:gcab

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

mkdir build
cd build/
meson --prefix=/usr --libdir=/usr/lib --sysconfdir=/etc --mandir=/usr/man -Dgtk-doc=false -Dstemmer=false -Drpm=false ..
ninja
sudo ninja install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
