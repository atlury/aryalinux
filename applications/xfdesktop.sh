#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:exo
#REQ:libwnck
#REQ:libxfce4ui
#REQ:libnotify
#REQ:startup-notification
#REQ:thunar


cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfdesktop/4.14/xfdesktop-4.14.2.tar.bz2


NAME=xfdesktop
VERSION=4.14.2
URL=http://archive.xfce.org/src/xfce/xfdesktop/4.14/xfdesktop-4.14.2.tar.bz2
SECTION="Xfce Desktop"
DESCRIPTION="Xfdesktop is a desktop manager for the Xfce Desktop Environment. Xfdesktop sets the background image / color, creates the right click menu and window list and displays the file icons on the desktop using Thunar libraries."

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


./configure --prefix=/usr &&
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

