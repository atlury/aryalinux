#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libassuan
URL=https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2
DESCRIPTION="The libassuan package contains an inter process communication library used by some of the other GnuPG related packages. libassuan's primary use is to allow a client to interact with a non-persistent server. libassuan is not, however, limited to use with GnuPG servers and clients. It was designed to be flexible enough to meet the demands of many transaction based environments with non-persistent servers."
VERSION=2.5.3

#REQ:libgpg-error

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/libassuan/libassuan-2.5.3.tar.bz2

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
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
