#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=at-spi2-atk
URL=http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.32/at-spi2-atk-2.32.0.tar.xz
DESCRIPTION="The At-Spi2 Atk package contains a library that bridges ATK to At-Spi2 D-Bus service."
VERSION=2.32.0

#REQ:at-spi2-core
#REQ:atk

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.32/at-spi2-atk-2.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.32/at-spi2-atk-2.32.0.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
