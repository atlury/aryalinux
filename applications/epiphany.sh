#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=epiphany
URL=http://ftp.gnome.org/pub/gnome/sources/epiphany/3.30/epiphany-3.30.3.tar.xz
DESCRIPTION="Epiphany is a simple yet powerful GNOME web browser targeted at non-technical users. Its principles are simplicity and standards compliance."
VERSION=3.30.3

#REQ:gcr
#REQ:gnome-desktop
#REQ:iso-codes
#REQ:json-glib
#REQ:libdazzle
#REQ:libnotify
#REQ:libwnck
#REQ:webkitgtk
#REC:nss

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/epiphany/3.30/epiphany-3.30.3.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/epiphany/3.30/epiphany-3.30.3.tar.xz

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

meson --prefix=/usr .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
