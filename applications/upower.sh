#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The UPower package provides an interface to enumerating power devices, listening to device events and querying history and statistics. Any application or service on the system can access the org.freedesktop.UPower service via the system message bus."
SECTION="general"
VERSION=0.99.7
NAME="upower"

#REQ:dbus-glib
#REQ:libgudev
#REQ:libusb
#REQ:polkit
#OPT:gobject-introspection
#OPT:gtk-doc
#OPT:python-modules#pygobject3


cd $SOURCE_DIR

URL=https://upower.freedesktop.org/releases/upower-0.99.7.tar.xz

if [ ! -z $URL ]
then
wget -nc https://upower.freedesktop.org/releases/upower-0.99.7.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/upower/upower-0.99.7.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/upower/upower-0.99.7.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/upower/upower-0.99.7.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/upower/upower-0.99.7.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/upower/upower-0.99.7.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/upower/upower-0.99.7.tar.xz

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --localstatedir=/var \
            --enable-deprecated  \
            --disable-static     &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
systemctl enable upower

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
