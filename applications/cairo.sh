#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cairo
URL=https://www.cairographics.org/releases/cairo-1.16.0.tar.xz
DESCRIPTION="Cairo is a 2D graphics library with support for multiple output devices. Currently supported output targets include the X Window System, win32, image buffers, PostScript, PDF and SVG. Experimental backends include OpenGL, Quartz and XCB file output. Cairo is designed to produce consistent output on all output media while taking advantage of display hardware acceleration when available (e.g., through the X Render Extension). The Cairo API provides operations similar to the drawing operators of PostScript and PDF. Operations in Cairo include stroking and filling cubic Bezier splines, transforming and compositing translucent images, and antialiased text rendering. All drawing operations can be transformed by any affine transformation(scale, rotation, shear, etc.)."
VERSION=1.16.0

#REQ:libpng
#REQ:pixman
#REC:fontconfig
#REC:glib2
#REC:x7lib

cd $SOURCE_DIR

wget -nc https://www.cairographics.org/releases/cairo-1.16.0.tar.xz

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
--enable-tee &&
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
