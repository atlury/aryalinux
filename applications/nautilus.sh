#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:bubblewrap
#REQ:gexiv2
#REQ:gnome-autoar
#REQ:gnome-desktop
#REQ:libnotify
#REQ:libseccomp
#REQ:tracker-miners
#REQ:desktop-file-utils
#REQ:exempi
#REQ:gobject-introspection
#REQ:gst10-plugins-base
#REQ:libexif
#REQ:adwaita-icon-theme
#REQ:gvfs


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/nautilus/3.34/nautilus-3.34.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/nautilus/3.34/nautilus-3.34.2.tar.xz


NAME=nautilus
VERSION=3.34.2
URL=http://ftp.gnome.org/pub/gnome/sources/nautilus/3.34/nautilus-3.34.2.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

meson --prefix=/usr      \
      --sysconfdir=/etc  \
      -Dselinux=false    \
      -Dpackagekit=false \
      .. &&

ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
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



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

