#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-color-manager
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-color-manager/3.32/gnome-color-manager-3.32.0.tar.xz
DESCRIPTION="GNOME Color Manager is a session framework for the GNOME desktop environment that makes it easy to manage, install and generate color profiles."
VERSION=3.32.0

#REQ:colord-gtk
#REQ:colord
#REQ:gtk3
#REQ:itstool
#REQ:lcms2
#REQ:libcanberra
#REQ:libexif
#REC:exiv2
#REC:vte

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-color-manager/3.32/gnome-color-manager-3.32.0.tar.xz

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

sed /subdir\(\'man/d -i meson.build
mkdir build &&
cd build &&

meson --prefix=/usr -Dexiv=false .. &&
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
