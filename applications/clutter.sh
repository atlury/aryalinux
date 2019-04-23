#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=clutter
URL=http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.2.tar.xz
DESCRIPTION="The Clutter package contains an open source software library used for creating fast, visually rich and animated graphical user interfaces."
VERSION=1.26.2

#REQ:atk
#REQ:cogl
#REQ:json-glib
#REC:gobject-introspection
#REC:gtk3
#REC:libgudev
#REC:libinput
#REC:libxkbcommon
#REC:wayland

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter/1.26/clutter-1.26.2.tar.xz

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
--enable-egl-backend \
--enable-evdev-input \
--enable-wayland-backend \
--enable-wayland-compositor &&
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
