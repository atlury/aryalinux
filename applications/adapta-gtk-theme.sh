#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=adapta-gtk-theme
URL=https://sourceforge.net/projects/aryalinux-bin/files/artifacts/adapta-gtk-theme.tar.xz
DESCRIPTION="Adapta GTK theme"
VERSION=20180311

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/artifacts/adapta-gtk-theme.tar.xz

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
