#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Cairo is a 2D graphics library with support for multiple output devices. Currently supported output targets include the X Window System, win32, image buffers, PostScript, PDF and SVG. Experimental backends include OpenGL, Quartz and XCB file output. Cairo is designed to produce consistent output on all output media while taking advantage of display hardware acceleration when available (e.g., through the X Render Extension). The Cairo API provides operations similar to the drawing operators of PostScript and PDF. Operations in Cairo include stroking and filling cubic B�zier splines, transforming and compositing translucent images, and antialiased text rendering. All drawing operations can be transformed by any <a class=\"ulink\" href=\"http://en.wikipedia.org/wiki/Affine_transformation\">affine transformation</a> (scale, rotation, shear, etc.)."
SECTION="x"
VERSION=1.14.12
NAME="cairo"

#REQ:libpng
#REQ:pixman
#REC:fontconfig
#REC:glib2
#REC:x7lib
#OPT:cogl
#OPT:gs
#OPT:gtk3
#OPT:gtk2
#OPT:gtk-doc
#OPT:libdrm
#OPT:librsvg
#OPT:lzo
#OPT:mesa
#OPT:poppler
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.cairographics.org/releases/cairo-1.14.12.tar.xz

if [ ! -z $URL ]
then
wget -nc https://www.cairographics.org/releases/cairo-1.14.12.tar.xz || wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz || wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz || wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz || wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz || wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz || wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/cairo/cairo-1.14.12.tar.xz

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

./configure --prefix=/usr    \
            --disable-static \
            --enable-tee &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
