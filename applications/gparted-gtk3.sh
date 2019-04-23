#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gparted-gtk3
URL=https://github.com/lb90/gparted-gtk3.git
DESCRIPTION="Gparted is the Gnome Partition Editor, a Gtk 2 GUI for other command line tools that can create, reorganise or delete disk partitions."
VERSION=0.31.0

#REQ:gtkmm2
#REQ:parted
#REQ:gnome-common
#REQ:gnome-doc-utils

cd $SOURCE_DIR


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

URL=https://github.com/lb90/gparted-gtk3.git
DIRECTORY=gparted-gtk3
git clone $URL
cd $DIRECTORY
./autogen.sh --prefix=/usr --disable-doc --disable-static &&
make
sudo make install
sudo cp -v /usr/share/applications/gparted.desktop /usr/share/applications/gparted.desktop.back &&
sudo sed -i 's/Exec=/Exec=sudo -A /' /usr/share/applications/gparted.desktop
cd $SOURCE_DIR
rm -rf gparted-gtk3

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
