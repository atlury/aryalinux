#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=telepathy-logger
URL=https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2
DESCRIPTION="The Telepathy Logger package is a headless observer client that logs information received by the Telepathy framework. It features pluggable backends to log different sorts of messages in different formats."
VERSION=0.8.2

#REQ:sqlite
#REQ:telepathy-glib
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc https://telepathy.freedesktop.org/releases/telepathy-logger/telepathy-logger-0.8.2.tar.bz2

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

sed 's@/apps/@/org/freedesktop/@' \
-i data/org.freedesktop.Telepathy.Logger.gschema.xml.in
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
