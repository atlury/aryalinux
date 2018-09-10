#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Folks is a library that aggregates people from multiple sources (e.g, Telepathy connection managers and eventually Evolution Data Server, Facebook, etc.) to create metacontacts."
SECTION="gnome"
VERSION=0.11.4
NAME="folks"

#REQ:evolution-data-server
#REQ:gobject-introspection
#REQ:libgee
#REQ:telepathy-glib
#REC:bluez
#REC:vala
#OPT:tracker


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/folks/0.11/folks-0.11.4.tar.xz

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

./configure --prefix=/usr --disable-fatal-warnings &&
make "-j`nproc`" || make
sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
