#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gtk2
URL=http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz
DESCRIPTION="The GTK+ 2 package contains libraries used for creating graphical user interfaces for applications."
VERSION=2.24.32

#REQ:atk
#REQ:gdk-pixbuf
#REQ:pango
#REC:hicolor-icon-theme

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.32.tar.xz

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

sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
-i docs/{faq,tutorial}/Makefile.in &&

./configure --prefix=/usr --sysconfdir=/etc &&

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
