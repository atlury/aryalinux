#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-keyring
URL=http://ftp.acc.umu.se/pub/gnome/sources/gnome-keyring/3.31/gnome-keyring-3.31.91.tar.xz
DESCRIPTION="The GNOME Keyring package contains a daemon that keeps passwords and other secrets for users."
VERSION=3.31.91

#REQ:dbus
#REQ:gcr
#REC:linux-pam
#REC:libxslt
#REC:openssh

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gnome-keyring/3.31/gnome-keyring-3.31.91.tar.xz

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

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--with-pam-dir=/lib/security &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
