#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:itstool
#REQ:cpio
#REQ:desktop-file-utils
#REQ:json-glib
#REQ:libarchive
#REQ:libnotify
#REQ:nautilus


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/file-roller/3.32/file-roller-3.32.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/file-roller/3.32/file-roller-3.32.2.tar.xz


NAME=file-roller
VERSION=3.32.2
URL=http://ftp.gnome.org/pub/gnome/sources/file-roller/3.32/file-roller-3.32.2.tar.xz

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

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

meson --prefix=/usr -Dpackagekit=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
chmod -v 0755 /usr/libexec/file-roller/isoinfo.sh
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

