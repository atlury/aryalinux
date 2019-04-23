#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=mupdf
URL=http://www.mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz
DESCRIPTION="MuPDF is a lightweight PDF and XPS viewer."
VERSION=source

#REQ:x7lib
#REC:freeglut
#REC:harfbuzz
#REC:libjpeg
#REC:openjpeg2
#REC:curl

cd $SOURCE_DIR

wget -nc http://www.mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/mupdf-1.14.0-shared_libs-1.patch

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

patch -Np1 -i ../mupdf-1.14.0-shared_libs-1.patch &&

USE_SYSTEM_LIBS=yes make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
USE_SYSTEM_LIBS=yes \
make prefix=/usr \
build=release \
docdir=/usr/share/doc/mupdf-1.14.0 \
install &&

ln -sfv mupdf-x11 /usr/bin/mupdf &&
ldconfig
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
