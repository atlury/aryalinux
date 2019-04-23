#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=clucene
URL=https://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
DESCRIPTION="CLucene is a C++ version of Lucene, a high performance text search engine."
VERSION=2.3.3.4

#REQ:cmake
#REC:boost

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/clucene/clucene-core-2.3.3.4.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/clucene-2.3.3.4-contribs_lib-1.patch

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

patch -Np1 -i ../clucene-2.3.3.4-contribs_lib-1.patch &&

mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DBUILD_CONTRIBS_LIB=ON .. &&
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
