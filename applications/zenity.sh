#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Zenity is a rewrite of gdialog, the GNOME port of dialog which allows you to display GTK+ dialog boxes from the command line and shell scripts."
SECTION="gnome"
VERSION=3.28.1
NAME="zenity"

#REQ:gtk3
#REQ:itstool
#REC:libnotify
#REC:libxslt
#OPT:webkitgtk


cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/zenity-3.28.1.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

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
sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
