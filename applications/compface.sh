#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=compface
URL=http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz
DESCRIPTION="Compface provides utilities and a library to convert from/to X-Face format, a 48x48 bitmap format used to carry thumbnails of email authors in a mail header."
VERSION=1.5.2


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz
wget -nc ftp://anduin.linuxfromscratch.org/BLFS/compface/compface-1.5.2.tar.gz

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

./configure --prefix=/usr --mandir=/usr/share/man &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -m755 -v xbm2xface.pl /usr/bin
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
