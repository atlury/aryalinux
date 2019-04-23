#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-shell-coverflow-alt-tab
URL=https://sourceforge.net/projects/aryalinux-bin/files/releases/1.5/gnome-shell-extensions/CoverflowAltTab-gnome-extension-36.tar.gz
DESCRIPTION=""
VERSION=36

#REQ:gnome-shell-extensions

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/1.5/gnome-shell-extensions/CoverflowAltTab-gnome-extension-36.tar.gz

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

sudo mkdir -pv /usr/share/gnome-shell/extensions/$(basename $(pwd))
sudo mv * /usr/share/gnome-shell/extensions/$(basename $(pwd))
sudo chmod -R a+r /usr/share/gnome-shell/extensions/$(basename $(pwd))

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
