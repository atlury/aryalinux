#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=thunar
URL=http://archive.xfce.org/src/xfce/thunar/1.8/Thunar-1.8.4.tar.bz2
DESCRIPTION="Thunar is the Xfce file manager, a GTK+ 2 GUI to organise the files on your computer."
VERSION=1.8.4

#REQ:exo
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libgudev
#REC:libnotify
#REC:xfce4-panel

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/thunar/1.8/Thunar-1.8.4.tar.bz2

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
--sysconfdir=/etc \
--docdir=/usr/share/doc/Thunar-1.8.4 &&
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
