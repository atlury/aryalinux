#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libfm-extra
URL=https://downloads.sourceforge.net/pcmanfm/libfm-1.3.1.tar.xz
DESCRIPTION="The libfm-extra package contains a library and other files required by <span class=\command\><strong>menu-cache-gen</strong> libexec of <a class=\xref\ href=\menu-cache.html\ title=\menu-cache-1.1.0\>menu-cache-1.1.0</a>."
VERSION=1.3.1

#REQ:glib2

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/pcmanfm/libfm-1.3.1.tar.xz

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--with-extra-only \
--with-gtk=no \
--disable-static &&
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
