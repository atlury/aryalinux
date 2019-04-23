#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=telepathy-glib
URL=https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz
DESCRIPTION="The Telepathy GLib contains a library used by GLib based Telepathy components. Telepathy is a D-Bus framework for unifying real time communication, including instant messaging, voice calls and video calls. It abstracts differences between protocols to provide a unified interface for applications."
VERSION=0.24.1

#REQ:dbus-glib
#REQ:libxslt
#REC:gobject-introspection
#REC:vala

cd $SOURCE_DIR

wget -nc https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.1.tar.gz

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
--enable-vala-bindings \
--disable-static &&
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
