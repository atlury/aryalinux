#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=simple-scan
URL=https://launchpad.net/simple-scan/3.25/3.25.1/+download/simple-scan-3.25.1.tar.xz
DESCRIPTION=""
VERSION=3.25.1

#REQ:packagekit
#REQ:sane
#REQ:itstool

cd $SOURCE_DIR

wget -nc $URL
wget -nc https://launchpadlibrarian.net/316974617/simple-scan-3.25.1-fix-vala-syntax.patch

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
