#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=imagemagick6
URL=https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-27.tar.xz
DESCRIPTION="ImageMagick underwent many changes in its libraries between versions 6 and 7. Most packages in BLFS which use ImageMagick can use version 7, but for the others this page will install only the libraries, headers and general documentation (not programs, manpages, perl modules), and it will rename the unversioned pkgconfig files so that they do not overwrite the same-named files from version 7."
VERSION=27

#REC:x7lib

cd $SOURCE_DIR

wget -nc https://www.imagemagick.org/download/releases/ImageMagick-6.9.10-27.tar.xz
wget -nc ftp://ftp.imagemagick.org/pub/ImageMagick/releases/ImageMagick-6.9.10-27.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/ImageMagick-6.9.10-27-libs_only-1.patch
wget -nc http://www.mcmurchy.com/ralcgm/ralcgm-3.51.tar.gz
wget -nc http://www.mcmurchy.com/urt/urt-3.1b.tar.gz

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

patch -Np1 -i ../ImageMagick-6.9.10-27-libs_only-1.patch &&
autoreconf -fi &&
./configure --prefix=/usr \
--sysconfdir=/etc \
--enable-hdri \
--with-modules \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DOCUMENTATION_PATH=/usr/share/doc/imagemagick-6.9.10 install-libs-only
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
