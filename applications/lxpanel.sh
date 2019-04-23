#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxpanel
URL=https://downloads.sourceforge.net/lxde/lxpanel-0.10.0.tar.xz
DESCRIPTION="The LXPanel package contains a lightweight X11 desktop panel."
VERSION=0.10.0

#REQ:keybinder
#REQ:libwnck2
#REQ:lxmenu-data
#REQ:menu-cache
#REC:alsa-lib
#REC:gnome-screenshot
#REC:libxml2
#REC:wireless_tools

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxde/lxpanel-0.10.0.tar.xz

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
