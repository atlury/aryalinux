#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libxcb
URL=https://xcb.freedesktop.org/dist/libxcb-1.13.1.tar.bz2
DESCRIPTION="The libxcb package provides an interface to the X Window System protocol, which replaces the current Xlib interface. Xlib can also use XCB as a transport layer, allowing software to make requests and receive responses with both."
VERSION=1.13.1

#REQ:libxau
#REQ:xcb-proto
#REC:libxdmcp

cd $SOURCE_DIR

wget -nc https://xcb.freedesktop.org/dist/libxcb-1.13.1.tar.bz2

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

sed -i "s/pthread-stubs//" configure &&

./configure $XORG_CONFIG \
--without-doxygen \
--docdir='${datadir}'/doc/libxcb-1.13.1 &&
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
