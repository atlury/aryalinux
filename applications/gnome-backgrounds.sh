#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-backgrounds
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.32/gnome-backgrounds-3.32.0.tar.xz
DESCRIPTION="The GNOME Backgrounds package contains a collection of graphics files which can be used as backgrounds in the GNOME Desktop environment. Additionally, the package creates the proper framework and directory structure so that you can add your own files to the collection."
VERSION=3.32.0


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.32/gnome-backgrounds-3.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-backgrounds/3.32/gnome-backgrounds-3.32.0.tar.xz

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
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
