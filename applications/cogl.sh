#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REQ:wayland
#REQ:gobject-introspection


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.4.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.4.tar.xz


NAME=cogl
VERSION=1.22.4
URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.4.tar.xz
SECTION="X Libraries"
DESCRIPTION="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


./configure --prefix=/usr --enable-gles1 --enable-gles2         \
    --enable-{kms,wayland,xlib}-egl-platform                    \
    --enable-wayland-egl-server                                 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

