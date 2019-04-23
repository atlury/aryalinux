#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=openssl
URL=https://openssl.org/source/openssl-1.1.1a.tar.gz
DESCRIPTION=""
VERSION=1.1.1a


cd $SOURCE_DIR

wget -nc https://openssl.org/source/openssl-1.1.1a.tar.gz

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

./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic
make
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
sudo make MANSUFFIX=ssl install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
