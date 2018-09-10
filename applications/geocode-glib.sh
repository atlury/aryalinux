#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Geocode GLib is a convenience library for the Yahoo! Place Finder APIs. The Place Finder web service allows to do geocoding (finding longitude and latitude from an address), and reverse geocoding (finding an address from coordinates)."
SECTION="gnome"
VERSION=3.26.0
NAME="geocode-glib"

#REQ:gtk-doc
#REQ:json-glib
#REQ:libsoup
#REC:gobject-introspection


cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/geocode-glib-3.26.0.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

mkdir build            &&
cd    build            &&
meson --prefix /usr .. &&
ninja
sudo ninja install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
