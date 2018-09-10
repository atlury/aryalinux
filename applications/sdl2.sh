#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Simple DirectMedia Layer Version 2 (SDL2 for short) is a cross-platform library designed to make it easy to write multimedia software, such as games and emulators."
SECTION="multimedia"
VERSION=2.0.8
NAME="sdl2"

#OPT:doxygen
#OPT:ibus
#OPT:nasm
#OPT:pulseaudio
#OPT:xorg-server


cd $SOURCE_DIR

URL=http://www.libsdl.org/release/SDL2-2.0.8.tar.gz

if [ ! -z $URL ]
then
wget -nc http://www.libsdl.org/release/SDL2-2.0.8.tar.gz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/SDL/SDL2-2.0.8.tar.gz

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
make install              &&
rm -v /usr/lib/libSDL2*.a

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
