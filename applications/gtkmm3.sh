#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Gtkmm package provides a C++ interface to GTK+ 3."
SECTION="x"
VERSION=3.93.0
NAME="gtkmm3"

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm


cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/gtkmm-3.93.0.tar.xz

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

sed -e '/^libdocdir =/ s/$(book_name)/gtkmm-$VERSION/' \
    -i docs/Makefile.in


./configure --prefix=/usr &&
make "-j`nproc`" || make
sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
