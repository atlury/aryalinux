#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libbamf3
URL=https://launchpad.net/bamf/0.5/0.5.4/+download/bamf-0.5.4.tar.gz
DESCRIPTION="bamf Removes the headache of applications matching into a simple DBus daemon and c wrapper library."
VERSION=0.5.4

#REQ:libwnck
#REQ:libgtop
#REQ:libxslt
#REQ:libxml2py2

cd $SOURCE_DIR

wget -nc https://launchpad.net/bamf/0.5/0.5.4/+download/bamf-0.5.4.tar.gz

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

./configure --prefix=/usr &&
make
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
