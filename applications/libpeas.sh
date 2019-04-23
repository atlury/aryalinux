#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libpeas
URL=http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
DESCRIPTION="libpeas is a GObject based plugins engine, and is targeted at giving every application the chance to assume its own extensibility."
VERSION=1.22.0

#REQ:gobject-introspection
#REQ:gtk3
#REC:pygobject3

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libpeas/1.22/libpeas-1.22.0.tar.xz
wget -nc http://www.lua.org/ftp/lua-5.1.5.tar.gz

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
