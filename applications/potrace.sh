#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:llvm


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/potrace/potrace-1.15.tar.gz


NAME=potrace
VERSION=1.15
URL=https://downloads.sourceforge.net/potrace/potrace-1.15.tar.gz
SECTION="Miscellaneous"
DESCRIPTION="Potrace™ is a tool for transforming a bitmap (PBM, PGM, PPM, or BMP format) into one of several vector file formats."

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


./configure --prefix=/usr                        \
            --disable-static                     \
            --docdir=/usr/share/doc/potrace-1.15 \
            --enable-a4                          \
            --enable-metric                      \
            --with-libpotrace                    &&
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

