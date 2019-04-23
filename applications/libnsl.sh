#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libnsl
URL=https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz
DESCRIPTION="The libnsl package contains the public client interface for NIS(YP) and NIS+. It replaces the NIS library that used to be in GlibC."
VERSION=1.2.0

#REQ:rpcsvc-proto
#REQ:libtirpc

cd $SOURCE_DIR

wget -nc https://github.com/thkukuk/libnsl/archive/v1.2.0/libnsl-1.2.0.tar.gz

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

autoreconf -fi &&
./configure --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mv /usr/lib/libnsl.so.2* /lib &&
ln -sfv ../../lib/libnsl.so.2.0.0 /usr/lib/libnsl.so
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
