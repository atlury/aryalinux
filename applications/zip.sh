#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=zip
URL=https://downloads.sourceforge.net/infozip/zip30.tar.gz
DESCRIPTION="The Zip package contains Zip utilities. These are useful for compressing files into <code class=\filename\>ZIP archives."
VERSION=zip30


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/infozip/zip30.tar.gz
wget -nc ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz

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

make -f unix/Makefile generic_gcc

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
