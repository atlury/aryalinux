#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-maps
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-maps/3.32/gnome-maps-3.32.1.tar.xz
DESCRIPTION="GNOME Maps is a map application for GNOME."
VERSION=3.32.1

#REQ:clutter-gtk
#REQ:folks
#REQ:geoclue2
#REQ:geocode-glib
#REQ:gfbgraph
#REQ:gjs
#REQ:libchamplain

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-maps/3.32/gnome-maps-3.32.1.tar.xz

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
