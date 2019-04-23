#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cogl
URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz
DESCRIPTION="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."
VERSION=1.22.2

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REQ:wayland
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

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

sed -i 's/^#if COGL/#ifdef COGL/' cogl/winsys/cogl-winsys-egl.c &&

./configure --prefix=/usr --enable-gles1 --enable-gles2 \
--enable-{kms,wayland,xlib}-egl-platform \
--enable-wayland-egl-server &&
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
