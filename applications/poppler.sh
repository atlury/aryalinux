#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=poppler
URL=https://poppler.freedesktop.org/poppler-0.75.0.tar.xz
DESCRIPTION="The Poppler package contains a PDF rendering library and command line tools used to manipulate PDF files. This is useful for providing PDF rendering functionality as a shared library."
VERSION=0.75.0

#REQ:cmake
#REQ:fontconfig
#REC:cairo
#REC:lcms2
#REC:libjpeg
#REC:libpng
#REC:nss
#REC:openjpeg2

cd $SOURCE_DIR

wget -nc https://poppler.freedesktop.org/poppler-0.75.0.tar.xz
wget -nc https://poppler.freedesktop.org/poppler-data-0.4.9.tar.gz

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

mkdir build &&
cd build &&

cmake -DCMAKE_BUILD_TYPE=Release \
-DCMAKE_INSTALL_PREFIX=/usr \
-DTESTDATADIR=$PWD/testfiles \
-DENABLE_UNSTABLE_API_ABI_HEADERS=ON \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/poppler-0.75.0 &&
cp -vr ../glib/reference/html /usr/share/doc/poppler-0.75.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

tar -xf ../../poppler-data-0.4.9.tar.gz &&
cd poppler-data-0.4.9

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make prefix=/usr install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
