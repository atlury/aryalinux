#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rarian
URL=http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2
DESCRIPTION="The Rarian package is a documentation metadata library based on the proposed Freedesktop.org spec. Rarian is designed to be a replacement for ScrollKeeper."
VERSION=0.8.1

#REC:libxslt
#REC:docbook

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/rarian/0.8/rarian-0.8.1.tar.bz2

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
--disable-static \
--localstatedir=/var &&
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
