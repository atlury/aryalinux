#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gtk-doc
URL=http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz
DESCRIPTION="The GTK-Doc package contains a code documenter. This is useful for extracting specially formatted comments from the code to create API documentation. This package is <span class=\emphasis\><em>optional</em>; if it is not installed, packages will not build the documentation. This does not mean that you will not have any documentation. If GTK-Doc is not available, the install process will copy any pre-built documentation to your system."
VERSION=1.29

#REQ:docbook
#REQ:docbook-xsl
#REQ:itstool
#REQ:libxslt
#REC:highlight

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-doc/1.29/gtk-doc-1.29.tar.xz

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
