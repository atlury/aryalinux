#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=mutter
URL=http://ftp.acc.umu.se/pub/gnome/sources/mutter/3.32/mutter-3.32.0.tar.xz
DESCRIPTION="Mutter is the window manager for GNOME. It is not invoked directly, but from GNOME Session (on a machine with a hardware accelerated video driver)."
VERSION=3.32.0

#REQ:clutter
#REQ:gnome-desktop
#REQ:libwacom
#REQ:libxkbcommon
#REQ:upower
#REQ:zenity
#REQ:libpipewire
#REC:gobject-introspection
#REC:libcanberra
#REC:startup-notification
#REC:libinput
#REC:wayland
#REC:wayland-protocols
#REC:xorg-server
#REC:gtk3

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/mutter/3.32/mutter-3.32.0.tar.xz

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

mkdir -pv build &&
cd build

CFLAGS="-Wno-pointer-to-int-cast" meson --prefix=/usr &&
ninja
sudo ninja install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
