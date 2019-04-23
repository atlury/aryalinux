#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=exiv2
URL=http://www.exiv2.org/builds/exiv2-0.27.0-Source.tar.gz
DESCRIPTION="Exiv2 is a C++ library and a command line utility for managing image and video metadata."
VERSION=0.27.0a

#REQ:cmake
#REC:curl

cd $SOURCE_DIR

wget -nc http://www.exiv2.org/builds/exiv2-0.27.0-Source.tar.gz

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

sed -i '/conntest/s/^/#/' samples/CMakeLists.txt
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DEXIV2_ENABLE_VIDEO=yes \
-DEXIV2_ENABLE_WEBREADY=yes \
-DEXIV2_ENABLE_CURL=yes \
-DEXIV2_BUILD_SAMPLES=no \
-G "Unix Makefiles" .. &&
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
