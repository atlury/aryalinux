#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gtkmm3
URL=http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.24/gtkmm-3.24.1.tar.xz
DESCRIPTION="The Gtkmm package provides a C++ interface to GTK+ 3."
VERSION=3.24.1

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtkmm/3.24/gtkmm-3.24.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtkmm/3.24/gtkmm-3.24.1.tar.xz

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

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-3.24.1/' \
-i docs/Makefile.in
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
