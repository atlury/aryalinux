#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gtk-vnc
URL=http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz
DESCRIPTION="The Gtk VNC package contains a VNC viewer widget for GTK+. It is built using coroutines allowing it to be completely asynchronous while remaining single threaded."
VERSION=0.9.0

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REC:gobject-introspection
#REC:python2
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gtk-vnc/0.9/gtk-vnc-0.9.0.tar.xz

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
--with-gtk=3.0 \
--enable-vala \
--without-sasl &&
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
