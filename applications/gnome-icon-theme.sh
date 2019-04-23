#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-icon-theme
URL=http://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme/3.12/gnome-icon-theme-3.12.0.tar.xz
DESCRIPTION="The GNOME Icon Theme package contains an assortment of non-scalable icons of different sizes and themes."
VERSION=3.12.0

#REQ:gtk3
#REQ:gtk2
#REQ:hicolor-icon-theme
#REQ:icon-naming-utils

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme/3.12/gnome-icon-theme-3.12.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gnome-icon-theme/3.12/gnome-icon-theme-3.12.0.tar.xz

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

./configure --prefix=/usr &&
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
