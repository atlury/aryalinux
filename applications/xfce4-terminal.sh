#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfce4-terminal
URL=http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.7.4.tar.bz2
DESCRIPTION="Xfce4 Terminal is a GTK+3 terminal emulator. This is useful for running commands or programs in the comfort of an Xorg window; you can drag and drop files into the Xfce4 Terminal or copy and paste text with your mouse."
VERSION=0.8.7.4

#REQ:libxfce4ui
#REQ:vte

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfce4-terminal/0.8/xfce4-terminal-0.8.7.4.tar.bz2

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
