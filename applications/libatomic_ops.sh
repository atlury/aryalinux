#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libatomic_ops
URL=https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz
DESCRIPTION="libatomic_ops provides implementations for atomic memory update operations on a number of architectures. This allows direct use of these in reasonably portable code. Unlike earlier similar packages, this one explicitly considers memory barrier semantics, and allows the construction of code that involves minimum overhead across a variety of architectures."
VERSION=7.6.10


cd $SOURCE_DIR

wget -nc https://github.com/ivmai/libatomic_ops/releases/download/v7.6.10/libatomic_ops-7.6.10.tar.gz

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
--enable-shared \
--disable-static \
--docdir=/usr/share/doc/libatomic_ops-7.6.10 &&
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
