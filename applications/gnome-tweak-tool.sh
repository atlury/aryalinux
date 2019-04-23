#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnome-tweak-tool
URL=https://github.com/GNOME/gnome-tweaks/archive/3.29.2.tar.gz
DESCRIPTION="GNOME Tweak Tool is a simple program used to tweak advanced GNOME settings."
VERSION=3.29.2

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:python-modules#pygobject3

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

mkdir build &&
cd    build &&
meson --prefix=/usr &&
ninja



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
ninja install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
