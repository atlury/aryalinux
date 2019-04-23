#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-settings-daemon
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-settings-daemon/3.32/gnome-settings-daemon-3.32.0.tar.xz
DESCRIPTION="The GNOME Settings Daemon is responsible for setting various parameters of a GNOME Session and the applications that run under it."
VERSION=3.32.0

#REQ:colord
#REQ:fontconfig
#REQ:geoclue2
#REQ:gnome-desktop
#REQ:lcms2
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:librsvg
#REQ:libwacom
#REQ:pulseaudio
#REQ:systemd
#REQ:upower
#REQ:xorg-wacom-driver
#REC:alsa
#REC:cups
#REC:networkmanager
#REC:nss
#REC:wayland

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-settings-daemon/3.32/gnome-settings-daemon-3.32.0.tar.xz

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
