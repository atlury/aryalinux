#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

#REQ:clutter
#REQ:gtk3
#REQ:libgee
#REQ:libxklavier
#REQ:pygobject2
#REQ:pygobject3
#REC:vala
#OPT:gtk2
#OPT:dbus-python
#OPT:dconf
#OPT:pyatspi2

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz

NAME=caribou
VERSION=0.4.21
URL=http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

PYTHON=python3 ./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-gtk2-module \
--disable-static &&
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
