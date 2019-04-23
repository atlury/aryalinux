#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libunique3
URL=http://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz
DESCRIPTION=""
VERSION=3.0.2

#REQ:gtk2
#OPT:gobject-introspection
#OPT:gtk-doc

cd $SOURCE_DIR

wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/libunique/3.0/libunique-3.0.2.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libunique/libunique-3.0.2.tar.xz

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

autoreconf -fi &&
./configure --prefix=/usr  \
            --disable-dbus \
            --disable-static &&
make "-j`nproc`"



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo ./rootscript.sh
sudo rm rootscript.sh


cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
