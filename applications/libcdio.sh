#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libcdio
URL=https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz
DESCRIPTION="The libcdio is a library for CD-ROM and CD image access. The associated libcdio-cdparanoia library reads audio from the CD-ROM directly as data, with no analog step between, and writes the data to a file or pipe as .wav, .aifc or as raw 16 bit linear PCM."
VERSION=2.0.0


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz
wget -nc https://ftp.gnu.org/gnu/libcdio/libcdio-paranoia-10.2+2.0.0.tar.bz2

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

./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

tar -xf ../libcdio-paranoia-10.2+2.0.0.tar.bz2 &&
cd libcdio-paranoia-10.2+2.0.0 &&

./configure --prefix=/usr --disable-static &&
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
