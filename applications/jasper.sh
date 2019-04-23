#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=jasper
URL=http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz
DESCRIPTION="The JasPer Project is an open-source initiative to provide a free software-based reference implementation of the JPEG-2000 codec."
VERSION=2.0.14

#REQ:cmake
#REC:libjpeg

cd $SOURCE_DIR

wget -nc http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz

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

mkdir BUILD &&
cd BUILD &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DCMAKE_SKIP_INSTALL_RPATH=YES \
-DJAS_ENABLE_DOC=NO \
-DCMAKE_INSTALL_DOCDIR=/usr/share/doc/jasper-2.0.14 \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
