#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=network-manager-pptp
URL=https://ftp.gnome.org/pub/gnome/sources/NetworkManager-pptp/1.2/NetworkManager-pptp-1.2.8.tar.xz
DESCRIPTION=""
VERSION=1.2.8


cd $SOURCE_DIR

wget -nc https://ftp.gnome.org/pub/gnome/sources/NetworkManager-pptp/1.2/NetworkManager-pptp-1.2.8.tar.xz

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

if grep "gnome-desktop-environment" /etc/alps/installed-list &> /dev/null; then WITH_GNOME="--with-gnome"; fi
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var $WITH_GNOME &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
