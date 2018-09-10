#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION="Cogl is a modern 3D graphics API with associated utility APIs designed to expose the features of 3D graphics hardware using a direct state access API design, as opposed to the state-machine style of OpenGL."
SECTION="x"
VERSION=1.22.2
NAME="cogl"

#REQ:cairo
#REQ:gdk-pixbuf
#REQ:glu
#REQ:mesa
#REQ:pango
#REQ:wayland
#REC:gobject-introspection
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:sdl
#OPT:sdl2


cd $SOURCE_DIR

URL=http://ftp.gnome.org/pub/gnome/sources/cogl/1.22/cogl-1.22.2.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

sed -i 's/^#if COGL/#ifdef COGL/' cogl/winsys/cogl-winsys-egl.c &&
./configure --prefix=/usr \
	--enable-gles1 \
	--enable-gles2 \
	--enable-kms-egl-platform \
	--enable-wayland-egl-platform \
	--enable-xlib-egl-platform \
	--enable-wayland-egl-server \
    --enable-{kms,wayland,xlib}-egl-platform \
    --enable-wayland-egl-server &&
make "-j`nproc`" || make
sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
