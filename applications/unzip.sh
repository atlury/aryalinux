#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=unzip
URL=https://downloads.sourceforge.net/infozip/unzip60.tar.gz
DESCRIPTION="The UnZip package contains <code class=\filename\>ZIP extraction utilities. These are useful for extracting files from <code class=\filename\>ZIP archives. <code class=\filename\>ZIP archives are created with PKZIP or Info-ZIP utilities, primarily in a DOS environment."
VERSION=unzip60


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/infozip/unzip60.tar.gz
wget -nc ftp://ftp.info-zip.org/pub/infozip/src/unzip60.tgz

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

make -f unix/Makefile generic

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make prefix=/usr MANDIR=/usr/share/man/man1 \
-f unix/Makefile install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
