#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gimp
URL=https://download.gimp.org/pub/gimp/v2.10/gimp-2.10.8.tar.bz2
DESCRIPTION="The Gimp package contains the GNU Image Manipulation Program which is useful for photo retouching, image composition and image authoring."
VERSION=2.10.8

#REQ:gegl
#REQ:gexiv2
#REQ:glib-networking
#REQ:gtk2
#REQ:harfbuzz
#REQ:libjpeg
#REQ:libmypaint
#REQ:librsvg
#REQ:libtiff
#REQ:libxml2py2
#REQ:lcms2
#REQ:mypaint-brushes
#REQ:poppler
#REC:dbus-glib
#REC:gs
#REC:gvfs
#REC:iso-codes
#REC:libgudev
#REC:pygtk
#REC:xdg-utils

cd $SOURCE_DIR

wget -nc https://download.gimp.org/pub/gimp/v2.10/gimp-2.10.8.tar.bz2
wget -nc http://anduin.linuxfromscratch.org/BLFS/gimp/gimp-help-2018-08-21.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
