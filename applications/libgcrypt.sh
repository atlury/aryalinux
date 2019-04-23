#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libgcrypt
URL=https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.4.tar.bz2
DESCRIPTION="The libgcrypt package contains a general purpose crypto library based on the code used in GnuPG. The library provides a high level interface to cryptographic building blocks using an extendable and flexible API."
VERSION=1.8.4

#REQ:libgpg-error

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.8.4.tar.bz2

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

./configure --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -dm755 /usr/share/doc/libgcrypt-1.8.4 &&
install -v -m644 README doc/{README.apichanges,fips*,libgcrypt*} \
/usr/share/doc/libgcrypt-1.8.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
