#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=freetype2-without-harfbuzz
URL=https://downloads.sourceforge.net/freetype/freetype-2.9.1.tar.bz2
DESCRIPTION="The FreeType2 package contains a library which allows applications to properly render TrueType fonts."
VERSION=2.9.1

#REC:libpng
#REC:general_which

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/freetype/freetype-2.9.1.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-2.9.1.tar.bz2
wget -nc https://downloads.sourceforge.net/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/freetype/freetype-doc-2.9.1.tar.bz2

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

tar -xf ../freetype-doc-2.9.1.tar.bz2 --strip-components=2 -C docs


sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&
./configure --prefix=/usr --without-harfbuzz --enable-freetype-config --disable-static &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/freetype-2.9.1 &&
cp -v -R docs/*     /usr/share/doc/freetype-2.9.1

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
