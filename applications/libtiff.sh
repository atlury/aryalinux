#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libtiff
URL=http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz
DESCRIPTION="The LibTIFF package contains the TIFF libraries and associated utilities. The libraries are used by many programs for reading and writing TIFF files and the utilities are used for general work with TIFF files."
VERSION=4.0.10

#REC:cmake

cd $SOURCE_DIR

wget -nc http://download.osgeo.org/libtiff/tiff-4.0.10.tar.gz

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

mkdir -p libtiff-build &&
cd libtiff-build &&

cmake -DCMAKE_INSTALL_DOCDIR=/usr/share/doc/libtiff-4.0.10 \
-DCMAKE_INSTALL_PREFIX=/usr -G Ninja .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
