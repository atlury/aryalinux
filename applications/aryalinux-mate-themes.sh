#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=aryalinux-mate-themes
URL=
DESCRIPTION=""
VERSION=


cd $SOURCE_DIR

wget -nc "https://sourceforge.net/projects/aryalinux-bin/files/artifacts/Ambiance&Radiance-Flat-Colors-16-04-1-LTS-GTK-3-18Theme.tar.gz"
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/Vibrancy-Colors-GTK-Icon-Theme-v-2-7.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/Vivacious-Colors-GTK-Icon-Theme-v-1-4.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/wall.png
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/start-here.svg
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/arya-plymouth-theme.tar.gz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux-font.tar.xz
wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/aryalinux-wallpapers-2016.04.tar.gz

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
