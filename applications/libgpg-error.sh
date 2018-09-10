#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The libgpg-error package contains a library that defines common error values for all GnuPG components."
SECTION="general"
VERSION=1.31
NAME="libgpg-error"



cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.31.tar.bz2

if [ ! -z $URL ]
then
wget -nc https://www.gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/libgpg-error/libgpg-error-1.31.tar.bz2

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

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D README /usr/share/doc/libgpg-error-1.31/README

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
