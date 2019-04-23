#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=inkscape
URL=https://media.inkscape.org/dl/resources/file/inkscape-0.92.4.tar.bz2
DESCRIPTION="Inkscape is a what you see is what you get Scalable Vector Graphics editor. It is useful for creating, viewing and changing SVG images."
VERSION=0.92.4

#REQ:boost
#REQ:gc
#REQ:gsl
#REQ:gtkmm2
#REQ:gtkmm3
#REQ:libxslt
#REQ:poppler
#REQ:popt
#REQ:wget
#REC:imagemagick6
#REC:lcms2
#REC:lcms
#REC:potrace
#REC:lxml
#REC:scour

cd $SOURCE_DIR

wget -nc https://media.inkscape.org/dl/resources/file/inkscape-0.92.4.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/inkscape-0.92.4-use_versioned_ImageMagick6-1.patch

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

patch -Np1 -i ../inkscape-0.92.4-use_versioned_ImageMagick6-1.patch
bash download-gtest.sh
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -v /usr/lib/inkscape/lib*_LIB.a
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
