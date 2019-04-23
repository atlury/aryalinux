#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=startup-notification
URL=https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz
DESCRIPTION="The startup-notification package contains <code class=\filename\>startup-notification libraries. These are useful for building a consistent manner to notify the user through the cursor that the application is loading."
VERSION=0.12

#REQ:x7lib
#REQ:xcb-util

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/startup-notification/releases/startup-notification-0.12.tar.gz

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

./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 -D doc/startup-notification.txt \
/usr/share/doc/startup-notification-0.12/startup-notification.txt
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
