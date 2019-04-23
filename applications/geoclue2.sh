#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=geoclue2
URL=https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.5.2/geoclue-2.5.2.tar.bz2
DESCRIPTION="GeoClue is a modular geoinformation service built on top of the D-Bus messaging system. The goal of the GeoClue project is to make creating location-aware applications as simple as possible."
VERSION=2.5.2

#REQ:json-glib
#REQ:libsoup
#REC:modemmanager
#REC:vala
#REC:avahi

cd $SOURCE_DIR

wget -nc https://gitlab.freedesktop.org/geoclue/geoclue/-/archive/2.5.2/geoclue-2.5.2.tar.bz2

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

meson --prefix=/usr --sysconfdir=/etc -Dgtk-doc=false .. &&
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
