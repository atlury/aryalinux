#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-doc-utils
URL=https://ftp.gnome.org/pub/GNOME/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz
DESCRIPTION=""
VERSION=0.20.10

#REQ:gnome-desktop-environment

cd $SOURCE_DIR

wget -nc https://ftp.gnome.org/pub/GNOME/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
