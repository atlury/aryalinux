#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=fontforge
URL=https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz
DESCRIPTION="The FontForge package contains an outline font editor that lets you create your own postscript, truetype, opentype, cid-keyed, multi-master, cff, svg and bitmap (bdf, FON, NFNT) fonts, or edit existing ones."
VERSION=20170731

#REQ:freetype2
#REQ:glib2
#REQ:libxml2
#REC:cairo
#REC:gtk2
#REC:harfbuzz
#REC:pango
#REC:desktop-file-utils
#REC:shared-mime-info
#REC:x7lib

cd $SOURCE_DIR

wget -nc https://github.com/fontforge/fontforge/releases/download/20170731/fontforge-dist-20170731.tar.xz

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
--enable-gtk2-use \
--disable-static \
--docdir=/usr/share/doc/fontforge-20170731 &&
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
