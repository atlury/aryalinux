#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=bluefish
URL=http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2
DESCRIPTION="Bluefish is a GTK+ text editor targeted towards programmers and web designers, with many options to write websites, scripts and programming code. Bluefish supports many programming and markup languages, and it focuses on editing dynamic and interactive websites."
VERSION=2.2.10

#REQ:gtk2
#REQ:gtk3
#REC:desktop-file-utils

cd $SOURCE_DIR

wget -nc http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.10.tar.bz2

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

./configure --prefix=/usr --docdir=/usr/share/doc/bluefish-2.2.10 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
