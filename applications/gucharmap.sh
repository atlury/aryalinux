#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gucharmap
URL=http://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz
DESCRIPTION="Gucharmap is a Unicode character map and font viewer. It allows you to browse through all the available Unicode characters and categories for the installed fonts, and to examine their detailed properties. It is an easy way to find the character you might only know by its Unicode name or code point."
VERSION=11.0.3

#REQ:desktop-file-utils
#REQ:gtk3
#REQ:itstool
#REQ:unzip
#REQ:wget
#REC:gobject-introspection
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gucharmap/11.0/gucharmap-11.0.3.tar.xz

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

LIBS="-ldl" \
./configure --prefix=/usr \
--enable-vala \
--with-unicode-data=download &&
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
