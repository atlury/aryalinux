#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xorgproto
URL=https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2
DESCRIPTION="The xorgproto package provides the header files required to build the X Window system, and to allow other applications to build against the installed X Window system."
VERSION=2018.4

#REQ:util-macros

cd $SOURCE_DIR

wget -nc https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2018.4.tar.bz2

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

mkdir build &&
cd build &&

meson --prefix=$XORG_PREFIX .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

install -vdm 755 $XORG_PREFIX/share/doc/xorgproto-2018.4 &&
install -vm 644 ../[^m]*.txt ../PM_spec $XORG_PREFIX/share/doc/xorgproto-2018.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
