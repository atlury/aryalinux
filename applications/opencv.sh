#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake
#REQ:unzip
#REQ:ffmpeg
#REQ:gst10-plugins-base
#REQ:gtk3
#REQ:jasper
#REQ:libjpeg
#REQ:libpng
#REQ:libtiff
#REQ:libwebp
#REQ:v4l-utils
#REQ:xine-lib


cd $SOURCE_DIR

wget -nc https://github.com/opencv/opencv/archive/4.1.2/opencv-4.1.2.tar.gz
wget -nc https://github.com/opencv/opencv_contrib/archive/4.1.2/opencv_contrib-4.1.2.tar.gz


NAME=opencv
VERSION=4.1.2
URL=https://github.com/opencv/opencv/archive/4.1.2/opencv-4.1.2.tar.gz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


tar xf ../opencv_contrib-4.1.2.tar.gz
mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr      \
      -DCMAKE_BUILD_TYPE=Release       \
      -DENABLE_CXX11=ON                \
      -DBUILD_PERF_TESTS=OFF           \
      -DWITH_XINE=ON                   \
      -DBUILD_TESTS=OFF                \
      -DENABLE_PRECOMPILED_HEADERS=OFF \
      -DCMAKE_SKIP_RPATH=ON            \
      -DBUILD_WITH_DEBUG_INFO=OFF      \
      -Wno-dev  ..                     &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

