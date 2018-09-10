#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Baobab package contains a graphical directory tree analyzer."
SECTION="gnome"
VERSION=3.30.0
NAME="baobab"

#REQ:adwaita-icon-theme
#REQ:gtk3
#REQ:itstool
#REQ:vala


cd $SOURCE_DIR

URL=https://download.gnome.org/sources/baobab/3.30/baobab-3.30.0.tar.xz

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

mkdir build &&
cd    build &&
meson --prefix=/usr .. &&
ninja
sudo ninja install
sudo sed -i "s@MimeType=inode/directory@#MimeType=inode/directory@g" /usr/share/applications/org.gnome.baobab.desktop
sudo update-desktop-database
sudo update-mime-database /usr/share/mime

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
