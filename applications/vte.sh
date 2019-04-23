#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=vte
URL=http://ftp.gnome.org/pub/gnome/sources/vte/0.56/vte-0.56.0.tar.xz
DESCRIPTION="The VTE package contains a termcap file implementation for terminal emulators."
VERSION=0.56.0

#REQ:gtk3
#REQ:libxml2
#REQ:pcre2
#REC:gobject-introspection
#REC:gnutls

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/vte/0.56/vte-0.56.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/vte/0.56/vte-0.56.0.tar.xz

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
--disable-static \
--enable-introspection &&
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
