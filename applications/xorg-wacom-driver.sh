#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xorg-wacom-driver
URL=https://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.36.0.tar.bz2
DESCRIPTION=""
VERSION=0.36.0

#REQ:xorg-server

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/linuxwacom/xf86-input-wacom-0.36.0.tar.bz2

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
--with-udev-rules-dir=/lib/udev/rules.d \
--with-systemd-unit-dir=/lib/systemd/system &&
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
