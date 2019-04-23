#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lightdm-gtk-greeter
URL=https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/lightdm-gtk-greeter/2.0.1-2ubuntu4/lightdm-gtk-greeter_2.0.1.orig.tar.gz
DESCRIPTION="GTK Based greeter for lightdm display manager"
VERSION=2.0.1

#REQ:xserver-meta
#REQ:itstool
#REQ:libgcrypt
#REQ:libxklavier
#REQ:systemd
#REQ:polkit
#REQ:lightdm
#REQ:aryalinux-wallpapers
#REQ:flat-remix-icon-theme
#REQ:adapta-gtk-theme
#REQ:accountsservice
#REC:aryalinux-fonts

cd $SOURCE_DIR

wget -nc $URL

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
