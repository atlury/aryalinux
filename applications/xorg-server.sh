#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xorg-server
URL=https://www.x.org/pub/individual/xserver/xorg-server-1.20.4.tar.bz2
DESCRIPTION="The Xorg Server is the core of the X Window system."
VERSION=1.20.4

#REQ:pixman
#REQ:x7font
#REQ:xkeyboard-config
#REC:libepoxy
#REC:wayland
#REC:wayland-protocols
#REC:systemd

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/xserver/xorg-server-1.20.4.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/xserver/xorg-server-1.20.4.tar.bz2

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
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG \
--enable-glamor \
--enable-suid-wrapper \
--with-xkb-output=/var/lib/xkb &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mkdir -pv /etc/X11/xorg.conf.d
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
