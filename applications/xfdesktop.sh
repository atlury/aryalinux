#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfdesktop
URL=http://archive.xfce.org/src/xfce/xfdesktop/4.12/xfdesktop-4.12.4.tar.bz2
DESCRIPTION="Xfdesktop is a desktop manager for the Xfce Desktop Environment. Xfdesktop sets the background image / color, creates the right click menu and window list and displays the file icons on the desktop using Thunar libraries."
VERSION=4.12.4

#REQ:exo
#REQ:libwnck2
#REQ:libxfce4ui
#REC:libnotify
#REC:startup-notification
#REC:thunar

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfdesktop/4.12/xfdesktop-4.12.4.tar.bz2

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

./configure --prefix=/usr &&
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
