#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gtk3
URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.7.tar.xz
DESCRIPTION="The GTK+ 3 package contains libraries used for creating graphical user interfaces for applications."
VERSION=3.24.7

#REQ:at-spi2-atk
#REQ:fribidi
#REQ:gdk-pixbuf
#REQ:libepoxy
#REQ:pango
#REC:adwaita-icon-theme
#REC:hicolor-icon-theme
#REC:iso-codes
#REC:libxkbcommon
#REC:wayland
#REC:wayland-protocols
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.24/gtk+-3.24.7.tar.xz

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--enable-broadway-backend \
--enable-x11-backend \
--enable-wayland-backend &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
