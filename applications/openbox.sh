#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=openbox
URL=http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz
DESCRIPTION="Openbox is a highly configurable desktop window manager with extensive standards support. It allows you to control almost every aspect of how you interact with your desktop."
VERSION=3.6.1

#REQ:pango

cd $SOURCE_DIR

wget -nc http://openbox.org/dist/openbox/openbox-3.6.1.tar.gz
wget -nc http://ftp.de.debian.org/debian/pool/main/n/numlockx/numlockx_1.2.orig.tar.gz

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

export XORG_PREFIX=/usr

export LIBRARY_PATH=$XORG_PREFIX/lib
2to3 -w data/autostart/openbox-xdg-autostart &&
sed 's/python/python3/' -i data/autostart/openbox-xdg-autostart
./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-static \
--docdir=/usr/share/doc/openbox-3.6.1 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
