#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=dvd-rw-tools
URL=http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz
DESCRIPTION="The dvd+rw-tools package contains several utilities to master the DVD media, both +RW/+R and -R[W]. The principle tool is <span class=\command\><strong>growisofs</strong> which provides a way to both lay down <span class=\strong\><strong>and</strong> grow an ISO9660 file system on (as well as to burn an arbitrary pre-mastered image to) all supported DVD media. This is useful for creating a new DVD or adding to an existing image on a partially burned DVD."
VERSION=7.1


cd $SOURCE_DIR

wget -nc http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz

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

sed -i '/stat.h/a #include <sys/sysmacros.h>/' growisofs.c &&
sed -i '/stdlib/a #include <limits.h>' transport.hxx &&
make all rpl8 btcflash

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make prefix=/usr install &&
install -v -m644 -D index.html \
/usr/share/doc/dvd+rw-tools-7.1/index.html
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
