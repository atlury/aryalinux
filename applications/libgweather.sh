#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libgweather
URL=http://ftp.gnome.org/pub/gnome/sources/libgweather/3.32/libgweather-3.32.1.tar.xz
DESCRIPTION="The libgweather package is a library used to access weather information from online services for numerous locations."
VERSION=3.32.1

#REQ:geocode-glib
#REQ:gtk3
#REQ:libsoup
#REC:gobject-introspection
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libgweather/3.32/libgweather-3.32.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libgweather/3.32/libgweather-3.32.1.tar.xz

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
