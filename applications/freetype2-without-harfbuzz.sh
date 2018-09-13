#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The FreeType2 package contains a library which allows applications to properly render TrueType fonts."
SECTION="general"
VERSION=2.9.1
NAME="freetype2-without-harfbuzz"

#REC:libpng
#REC:general_which


cd $SOURCE_DIR

URL=https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2

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

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&
./configure --prefix=/usr --without-harfbuzz --enable-freetype-config --disable-static &&
make "-j`nproc`" || make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
