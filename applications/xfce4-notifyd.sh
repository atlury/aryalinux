#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Xfce4 Notification Daemon is a small program that implements the \"server-side\" portion of the Freedesktop desktop notifications specification. Applications that wish to pop up a notification bubble in a standard way can use Xfce4-Notifyd to do so by sending standard messages over D-Bus using the org.freedesktop.Notifications interface."
SECTION="xfce"
VERSION=0.4.2
NAME="xfce4-notifyd"

#REQ:libnotify
#REQ:libxfce4ui
#REQ:xfce4-panel


cd $SOURCE_DIR

URL=http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.2.tar.bz2

if [ ! -z $URL ]
then
wget -nc http://archive.xfce.org/src/apps/xfce4-notifyd/0.4/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2 || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/xfce/xfce4-notifyd-0.4.2.tar.bz2

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh


notify-send -i info Information "Hi ${USER}, This is a Test"




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
