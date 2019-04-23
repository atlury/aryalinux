#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gedit
URL=http://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.1.tar.xz
DESCRIPTION="The Gedit package contains a lightweight UTF-8 text editor for the GNOME Desktop."
VERSION=3.22.1

#REQ:gsettings-desktop-schemas
#REQ:gtksourceview
#REQ:itstool
#REQ:libpeas
#REC:gvfs
#REC:iso-codes
#REC:libsoup
#REC:pygobject3

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gedit/3.22/gedit-3.22.1.tar.xz

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

./configure --prefix=/usr --disable-spell &&
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
