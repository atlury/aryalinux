#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfce4-settings
URL=http://archive.xfce.org/src/xfce/xfce4-settings/4.12/xfce4-settings-4.12.4.tar.bz2
DESCRIPTION="The Xfce4 Settings package contains a collection of programs that are useful for adjusting your Xfce preferences."
VERSION=4.12.4

#REQ:exo
#REQ:garcon
#REQ:libxfce4ui
#REQ:gnome-icon-theme
#REQ:lxde-icon-theme
#REC:libcanberra
#REC:libnotify
#REC:libxklavier

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/xfce4-settings/4.12/xfce4-settings-4.12.4.tar.bz2

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

./configure --prefix=/usr --sysconfdir=/etc &&
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
