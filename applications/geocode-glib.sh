#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=geocode-glib
URL=http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.26/geocode-glib-3.26.1.tar.xz
DESCRIPTION="The Geocode GLib is a convenience library for the Yahoo! Place Finder APIs. The Place Finder web service allows to do geocoding (finding longitude and latitude from an address), and reverse geocoding (finding an address from coordinates)."
VERSION=3.26.1

#REQ:gtk-doc
#REQ:json-glib
#REQ:libsoup
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.26/geocode-glib-3.26.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/geocode-glib/3.26/geocode-glib-3.26.1.tar.xz

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
meson --prefix /usr .. &&
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
