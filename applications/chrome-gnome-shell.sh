#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Chrome gnome shell is Browser extension for Google Chrome/Chromium, Firefox, Vivaldi, Opera (and other Browser Extension, Chrome Extension or WebExtensions capable browsers) and native host messaging connector that provides integration with GNOME Shell and the corresponding extensions repository https://extensions.gnome.org/"
SECTION="gnome"
VERSION=10
NAME="chrome-gnome-shell"


cd $SOURCE_DIR

URL=https://download.gnome.org/sources/chrome-gnome-shell/10/chrome-gnome-shell-10.tar.xz

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

mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`" || make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
