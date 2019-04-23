#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lightdm-webkit2-greeter
URL=
DESCRIPTION="A webkit2 based greeter for lightdm"
VERSION=2.0.0

#REQ:git
#REQ:lightdm
#REQ:meson
#REQ:ninja
#REQ:webkitgtk
#REC:aryalinux-wallpapers
#REC:aryalinux-fonts
#REC:aryalinux-themes
#REC:aryalinux-icons

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/releases/2017.04/lightdm-webkit-material.tar.gz

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
