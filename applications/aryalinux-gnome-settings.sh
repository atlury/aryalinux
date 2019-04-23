#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=aryalinux-gnome-settings
URL=
DESCRIPTION="Fonts of the aryalinux XFCE, Mate, KDE and Gnome Desktops"
VERSION=1.4


cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux-gnome-defaults.tar.xz

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

sudo tar xf aryalinux-gnome-defaults.tar.xz -C /
sudo cp -r /etc/skel/{.config,.local,.bash,.Xresources}* ~
sudo chown -R $USER:$USER ~

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
