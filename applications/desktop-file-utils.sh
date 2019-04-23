#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=desktop-file-utils
URL=https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz
DESCRIPTION="The Desktop File Utils package contains command line utilities for working with <a class=\ulink\  href=\http://standards.freedesktop.org/desktop-entry-spec/latest/\>Desktop entries</a>. These utilities are used by Desktop Environments and other applications to manipulate the MIME-types application databases and help adhere to the Desktop Entry Specification."
VERSION=0.23

#REQ:glib2

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/desktop-file-utils/releases/desktop-file-utils-0.23.tar.xz

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vdm755 /usr/share/applications &&
update-desktop-database /usr/share/applications
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
