#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=b43-fwcutter
URL=http://bues.ch/b43/fwcutter/b43-fwcutter-018.tar.bz2
DESCRIPTION=""
VERSION=018

#REQ:xorg-server

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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
