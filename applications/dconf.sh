#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=dconf
URL=http://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
DESCRIPTION="The DConf package contains a low-level configuration system. Its main purpose is to provide a backend to GSettings on platforms that don't already have configuration storage systems."
VERSION=0.32.0

#REQ:dbus
#REQ:glib2
#REQ:gtk3
#REQ:libxml2
#REC:libxslt
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf/0.32/dconf-0.32.0.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.32/dconf-editor-3.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/dconf-editor/3.32/dconf-editor-3.32.0.tar.xz

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

meson --prefix=/usr --sysconfdir=/etc -Dbash_completion=false .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cd .. &&
tar -xf ../dconf-editor-3.32.0.tar.xz &&
cd dconf-editor-3.32.0 &&

mkdir build &&
cd build &&

meson --prefix=/usr --sysconfdir=/etc .. &&
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
