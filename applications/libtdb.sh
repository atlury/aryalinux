#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libtdb
URL=https://www.samba.org/ftp/tdb/tdb-1.3.17.tar.gz
DESCRIPTION="libtdb is a simple database API. It was inspired by the realisation that in Samba we have several ad-hoc bits of code that essentially implement small databases for sharing structures between parts of Samba."
VERSION=1.3.17


cd $SOURCE_DIR

wget -nc https://www.samba.org/ftp/tdb/tdb-1.3.17.tar.gz

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

sed -i "s@../../buildtools@buildtools@g" Makefile
./configure --prefix=/usr &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
