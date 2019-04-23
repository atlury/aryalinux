#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=caribou
URL=http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz
DESCRIPTION="Caribou is an input assistive technology intended for switch and pointer users."
VERSION=0.4.21

#REQ:clutter
#REQ:gtk3
#REQ:libgee
#REQ:libxklavier
#REQ:pygobject2
#REQ:pygobject3
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/caribou/0.4/caribou-0.4.21.tar.xz

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

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
