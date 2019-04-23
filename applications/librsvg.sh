#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=librsvg
URL=http://ftp.gnome.org/pub/gnome/sources/librsvg/2.44/librsvg-2.44.13.tar.xz
DESCRIPTION="The librsvg package contains a library and tools used to manipulate, convert and view Scalable Vector Graphic (SVG) images."
VERSION=2.44.13

#REQ:gdk-pixbuf
#REQ:libcroco
#REQ:cairo
#REQ:pango
#REQ:rust
#REC:gobject-introspection
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/librsvg/2.44/librsvg-2.44.13.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.44/librsvg-2.44.13.tar.xz

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

export PATH=$PATH:/opt/rustc/bin
./configure --prefix=/usr \
--enable-vala \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gdk-pixbuf-query-loaders --update-cache
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
