#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=grilo
URL=http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.7.tar.xz
DESCRIPTION="Grilo is a framework focused on making media discovery and browsing easy for applications and application developers."
VERSION=0.3.7

#REQ:glib2
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:libsoup
#REC:totem-pl-parser
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/grilo/0.3/grilo-0.3.7.tar.xz

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

mkdir build &&
cd build &&
meson --prefix=/usr \
--libexecdir=/usr/lib .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
