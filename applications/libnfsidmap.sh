#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libnfsidmap
URL=https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2
DESCRIPTION="The libnfsidmap package contains a library to help mapping id's, mainly for NFSv4."
VERSION=0.26


cd $SOURCE_DIR

wget -nc https://fedorapeople.org/~steved/libnfsidmap/0.26/libnfsidmap-0.26.tar.bz2

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mv -v /usr/lib/libnfsidmap.so.* /lib &&
ln -sfv ../../lib/$(readlink /usr/lib/libnfsidmap.so) /usr/lib/libnfsidmap.so
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
