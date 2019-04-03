#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

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

NAME=tracker
VERSION=2.2.1
URL=http://ftp.gnome.org/pub/gnome/sources/tracker/2.2/tracker-2.2.1.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

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


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
