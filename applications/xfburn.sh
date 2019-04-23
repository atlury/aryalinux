#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfburn
URL=http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.5.tar.bz2
DESCRIPTION="Xfburn is a GTK+ 2 GUI frontend for Libisoburn. This is useful for creating CDs and DVDs from files on your computer or ISO images downloaded from elsewhere."
VERSION=0.5.5

#REQ:exo
#REQ:libburn
#REQ:libisofs
#REQ:libxfce4ui

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/apps/xfburn/0.5/xfburn-0.5.5.tar.bz2

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
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
