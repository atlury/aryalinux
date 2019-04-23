#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gvfs
URL=http://ftp.gnome.org/pub/gnome/sources/gvfs/1.38/gvfs-1.38.1.tar.xz
DESCRIPTION="The Gvfs package is a userspace virtual filesystem designed to work with the I/O abstractions of GLib's GIO library."
VERSION=1.38.1

#REQ:dbus
#REQ:glib2
#REQ:libusb
#REQ:libsecret
#REQ:libsoup
#REC:gcr
#REC:gtk3
#REC:libcdio
#REC:libgdata
#REC:libgudev
#REC:systemd
#REC:udisks2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gvfs/1.38/gvfs-1.38.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gvfs/1.38/gvfs-1.38.1.tar.xz

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
-Dfuse=false \
-Dgphoto2=false \
-Dafc=false \
-Dbluray=false \
-Dnfs=false \
-Dmtp=false \
-Dsmb=false \
-Ddnssd=false \
-Dgoa=false \
-Dgoogle=false .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
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

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
