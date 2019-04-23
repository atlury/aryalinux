#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=telepathy-mission-control
URL=https://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz
DESCRIPTION="Telepathy Mission Control is an account manager and channel dispatcher for the Telepathy framework, allowing user interfaces and other clients to share connections to real-time communication services without conflicting."
VERSION=5.16.4

#REQ:telepathy-glib
#REC:networkmanager

cd $SOURCE_DIR

wget -nc https://telepathy.freedesktop.org/releases/telepathy-mission-control/telepathy-mission-control-5.16.4.tar.gz

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
