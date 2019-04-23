#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=network-manager-applet
URL=http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.20.tar.xz
DESCRIPTION="The NetworkManager Applet provides a tool and a panel applet used to configure wired and wireless network connections through GUI. It's designed for use with any desktop environment that uses GTK+ like Xfce and LXDE."
VERSION=1.8.20

#REQ:gcr
#REQ:gtk3
#REQ:iso-codes
#REQ:libsecret
#REQ:libnotify
#REQ:networkmanager
#REQ:polkit-gnome
#REC:gobject-introspection
#REC:modemmanager

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.20.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/network-manager-applet/1.8/network-manager-applet-1.8.20.tar.xz

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

meson --prefix=/usr \
--sysconfdir=/etc \
-Dselinux=false \
-Dteam=false \
-Dmobile_broadband_provider_info=false .. &&
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
