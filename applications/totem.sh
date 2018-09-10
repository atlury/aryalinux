#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Totem is movie player for the GNOME desktop based on GStreamer."
SECTION="gnome"
VERSION=3.26.2
NAME="totem"

#REQ:glib-networking
#REQ:libxml2
#REQ:sqlite
#REC:gobject-introspection
#REC:vala
#OPT:apache
#OPT:curl
#OPT:mitkrb
#OPT:gtk-doc
#OPT:php
#OPT:samba


cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/totem-3.26.2.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr --disable-static &&
make "-j`nproc`" || make
sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"