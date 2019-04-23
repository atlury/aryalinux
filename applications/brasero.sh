#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=brasero
URL=http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz
DESCRIPTION="Brasero is an application used to burn CD/DVD on the GNOME Desktop. It is designed to be as simple as possible and has some unique features that enable users to create their discs easily and quickly."
VERSION=3.12.2

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REC:gobject-introspection
#REC:libburn
#REC:libisoburn
#REC:libisofs
#REC:nautilus
#REC:totem-pl-parser
#REC:dvd-rw-tools
#REC:gvfs

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/brasero/3.12/brasero-3.12.2.tar.xz

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

./configure --prefix=/usr \
--enable-compile-warnings=no \
--enable-cxx-warnings=no &&
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
