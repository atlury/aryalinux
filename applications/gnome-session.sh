#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-session
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-session/3.32/gnome-session-3.32.0.tar.xz
DESCRIPTION="The GNOME Session package contains the GNOME session manager."
VERSION=3.32.0

#REQ:dbus-glib
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:systemd
#REQ:upower

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-session/3.32/gnome-session-3.32.0.tar.xz

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

sed 's@/bin/sh@/bin/sh -l@' -i gnome-session/gnome-session.in
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
