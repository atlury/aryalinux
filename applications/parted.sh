#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=parted
URL=https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
DESCRIPTION="The Parted package is a disk partitioning and partition resizing tool."
VERSION=3.2

#REC:lvm2

cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/parted/parted-3.2.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/parted-3.2-devmapper-1.patch

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

patch -Np1 -i ../parted-3.2-devmapper-1.patch
sed -i '/utsname.h/a#include <sys/sysmacros.h>' libparted/arch/linux.c &&

./configure --prefix=/usr --disable-static &&
make &&

make -C doc html &&
makeinfo --html -o doc/html doc/parted.texi &&
makeinfo --plaintext -o doc/parted.txt doc/parted.texi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m755 -d /usr/share/doc/parted-3.2/html &&
install -v -m644 doc/html/* \
/usr/share/doc/parted-3.2/html &&
install -v -m644 doc/{FAT,API,parted.{txt,html}} \
/usr/share/doc/parted-3.2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
