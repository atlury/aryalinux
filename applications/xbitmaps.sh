#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xbitmaps
URL=https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2
DESCRIPTION="The xbitmaps package contains bitmap images used by multiple applications built in Xorg chapter."
VERSION=1.1.2

#REQ:util-macros

cd $SOURCE_DIR

wget -nc https://www.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2
wget -nc ftp://ftp.x.org/pub/individual/data/xbitmaps-1.1.2.tar.bz2

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

./configure $XORG_CONFIG

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
