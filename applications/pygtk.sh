#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=pygtk
URL=http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
DESCRIPTION=""
VERSION=2.24.0

#REQ:python2
#REQ:atk
#REQ:pango
#REQ:pycairo
#REQ:pango
#REQ:pycairo
#REQ:gtk2
#REQ:pycairo
#REQ:libglade

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2

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

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
