#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=clutter-gst2
URL=http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz
DESCRIPTION=""
VERSION=2.0.14


cd $SOURCE_DIR

wget -nc ftp://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz
wget -nc http://ftp.gnome.org/pub/gnome/sources/clutter-gst/2.0/clutter-gst-2.0.14.tar.xz

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
