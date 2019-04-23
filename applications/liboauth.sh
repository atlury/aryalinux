#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=liboauth
URL=https://downloads.sourceforge.net/liboauth/liboauth-1.0.3.tar.gz
DESCRIPTION="liboauth is a collection of POSIX-C functions implementing the OAuth Core RFC 5849 standard. Liboauth provides functions to escape and encode parameters according to OAuth specification and offers high-level functionality to sign requests or verify OAuth signatures as well as perform HTTP requests."
VERSION=1.0.3

#REQ:curl

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/liboauth/liboauth-1.0.3.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/liboauth-1.0.3-openssl-1.1.0-3.patch

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

patch -Np1 -i ../liboauth-1.0.3-openssl-1.1.0-3.patch
./configure --prefix=/usr --disable-static &&
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
