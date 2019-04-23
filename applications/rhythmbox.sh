#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rhythmbox
URL=https://download.gnome.org/sources/rhythmbox/3.4/rhythmbox-3.4.3.tar.xz
DESCRIPTION="Rhythmbox is a music manager and player for gnome desktop environment"
VERSION=3.4.3

#REQ:gobject-introspection
#REQ:gtk3
#REQ:xserver-meta
#REQ:gdk-pixbuf
#REQ:glib2
#REQ:libsoup
#REQ:libpeas
#REQ:libxml2
#REQ:libtdb
#REQ:json-glib
#REQ:libmtp
#REQ:grilo
#REQ:libdmapsharing
#REQ:brasero
#REQ:libnotify
#REQ:libmusicbrainz5
#REQ:pygobject2
#REQ:libgpod
#REQ:yelp

cd $SOURCE_DIR

wget -nc https://download.gnome.org/sources/rhythmbox/3.4/rhythmbox-3.4.3.tar.xz

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

./configure --prefix=/usr
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
