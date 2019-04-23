#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libquicktime
URL=https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz
DESCRIPTION="The libquicktime package contains the <code class=\filename\>libquicktime library, various plugins and codecs, along with graphical and command line utilities used for encoding and decoding QuickTime files. This is useful for reading and writing files in the QuickTime format. The goal of the project is to enhance, while providing compatibility with the Quicktime 4 Linux library."
VERSION=1.2.4


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/libquicktime/libquicktime-1.2.4.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/libquicktime-1.2.4-ffmpeg4-1.patch

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

patch -Np1 -i ../libquicktime-1.2.4-ffmpeg4-1.patch &&

./configure --prefix=/usr \
--enable-gpl \
--without-doxygen \
--docdir=/usr/share/doc/libquicktime-1.2.4
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/libquicktime-1.2.4 &&
install -v -m644 README doc/{*.txt,*.html,mainpage.incl} \
/usr/share/doc/libquicktime-1.2.4
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
