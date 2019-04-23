#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rpcsvc-proto
URL=https://github.com/thkukuk/rpcsvc-proto/releases/download/v1.4/rpcsvc-proto-1.4.tar.gz
DESCRIPTION="The rpcsvc-proto package contains the rcpsvc protocol.x files and headers, formerly included with GlibC, that are not included in replacement <a class=\xref\ href=\libtirpc.html\ title=\libtirpc-1.0.3\>libtirpc-1.0.3</a>, along with the rpcgen program."
VERSION=1.4


cd $SOURCE_DIR

wget -nc https://github.com/thkukuk/rpcsvc-proto/releases/download/v1.4/rpcsvc-proto-1.4.tar.gz

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

./configure --sysconfdir=/etc &&
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
