#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Telepathy GLib contains a library used by GLib based Telepathy components. Telepathy is a D-Bus framework for unifying real time communication, including instant messaging, voice calls and video calls. It abstracts differences between protocols to provide a unified interface for applications."
SECTION="general"
VERSION=0.24.1
NAME="telepathy-glib"

#REQ:dbus-glib
#REQ:libxslt
#REC:gobject-introspection
#REC:vala
#OPT:gtk-doc


cd $SOURCE_DIR

URL=https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz

if [ ! -z $URL ]
then
wget -nc https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/telepathy-glib/telepathy-glib-0.24.1.tar.gz

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

./configure --prefix=/usr \
            --enable-vala-bindings \
            --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
