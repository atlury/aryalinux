#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=tracker
URL=http://ftp.gnome.org/pub/gnome/sources/tracker/2.2/tracker-2.2.1.tar.xz
DESCRIPTION="Tracker is the file indexing and search provider used in the GNOME desktop environment."
VERSION=2.2.1

#REQ:json-glib
#REQ:libseccomp
#REQ:libsoup
#REQ:vala
#REC:gobject-introspection
#REC:icu
#REC:networkmanager
#REC:sqlite
#REC:upower

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/tracker/2.2/tracker-2.2.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/tracker/2.2/tracker-2.2.1.tar.xz

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

meson --prefix=/usr --sysconfdir=/etc .. &&
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
