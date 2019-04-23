#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=playonlinux
URL=http://archive.ubuntu.com/ubuntu/pool/multiverse/p/playonlinux/playonlinux_4.2.2.orig.tar.gz
DESCRIPTION=""
VERSION=4.2.2

#REQ:cabextract
#REQ:curl
#REQ:gnupg
#REQ:icoutils
#REQ:imagemagick
#REQ:mesa
#REQ:netcat
#REQ:p7zip-full
#REQ:wxpython
#REQ:unzip
#REQ:wget
#REQ:wine
#REQ:x7util
#REQ:xterm

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
