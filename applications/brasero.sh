#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REC:gobject-introspection
#REC:libburn
#REC:libisoburn
#REC:libisofs
#REC:nautilus
#REC:totem-pl-parser
#REC:dvd-rw-tools
#REC:gvfs

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz

NAME=brasero
VERSION=3.12.2
URL=http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz

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

./configure --prefix=/usr \
--enable-compile-warnings=no \
--enable-cxx-warnings=no &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
