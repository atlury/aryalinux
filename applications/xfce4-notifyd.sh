#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfce4-notifyd
URL=http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.3.tar.bz2
DESCRIPTION="The Xfce4 Notification Daemon is a small program that implements the \server-side\ portion of the Freedesktop desktop notifications specification. Applications that wish to pop up a notification bubble in a standard way can use Xfce4-Notifyd to do so by sending standard messages over D-Bus using the org.freedesktop.Notifications interface."
VERSION=0.4.3

#REQ:libnotify
#REQ:libxfce4ui
#REQ:xfce4-panel

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.3.tar.bz2

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

notify-send -i info Information "Hi ${USER}, This is a Test"

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
