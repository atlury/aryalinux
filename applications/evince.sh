#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=evince
URL=http://ftp.acc.umu.se/pub/gnome/sources/evince/3.32/evince-3.32.0.tar.xz
DESCRIPTION="Evince is a document viewer for multiple document formats. It supports PDF, Postscript, DjVu, TIFF and DVI. It is useful for viewing documents of various types using one simple application instead of the multiple document viewers that once existed on the GNOME Desktop."
VERSION=3.32.0

#REQ:adwaita-icon-theme
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:libxml2
#REQ:openjpeg2
#REC:gnome-keyring
#REC:gobject-introspection
#REC:libsecret
#REC:nautilus
#REC:poppler

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/evince/3.32/evince-3.32.0.tar.xz

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
--enable-compile-warnings=minimum \
--enable-introspection \
--without-gspell \
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
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
