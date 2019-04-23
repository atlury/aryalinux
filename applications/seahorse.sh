#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=seahorse
URL=http://ftp.acc.umu.se/pub/gnome/sources/seahorse/3.32/seahorse-3.32.tar.xz
DESCRIPTION="Seahorse is a graphical interface for managing and using encryption keys. Currently it supports PGP keys (using GPG/GPGME) and SSH keys."
VERSION=3.32

#REQ:gcr
#REQ:gnupg
#REQ:gpgme
#REQ:itstool
#REQ:libsecret
#REQ:gnome-keyring
#REC:libsoup
#REC:p11-kit
#REC:openssh
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/seahorse/3.32/seahorse-3.32.tar.xz

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

sed -i -r 's:"(/apps):"/org/gnome\1:' data/*.xml &&

mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
