#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=eog
URL=http://ftp.acc.umu.se/pub/gnome/sources/eog/3.32/eog-3.32.0.tar.xz
DESCRIPTION="EOG is an application used for viewing and cataloging image files on the GNOME Desktop. It has basic editing capabilites."
VERSION=3.32.0

#REQ:adwaita-icon-theme
#REQ:exempi
#REQ:gnome-desktop
#REQ:itstool
#REQ:libjpeg
#REQ:libpeas
#REQ:shared-mime-info
#REC:gobject-introspection
#REC:lcms2
#REC:libexif
#REC:librsvg

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/eog/3.32/eog-3.32.0.tar.xz

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
