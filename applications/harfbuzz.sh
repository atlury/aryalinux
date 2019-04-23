#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=harfbuzz
URL=https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.4.0.tar.bz2
DESCRIPTION="The HarfBuzz package contains an OpenType text shaping engine."
VERSION=2.4.0

#REQ:graphite-wo-harfbuzz
#REQ:freetype2-wo-harfbuzz
#REC:glib2
#REC:graphite2
#REC:icu
#REC:freetype2

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-2.4.0.tar.bz2

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

./configure --prefix=/usr --with-gobject --with-graphite2 &&
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
