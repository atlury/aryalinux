#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libsigsegv
URL=https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz
DESCRIPTION="This is a library for handling page faults in user mode. A page fault occurs when a program tries to access to a region of memory that is currently not available. Catching and handling a page fault is a useful technique for implementing pageable virtual memory, memory-mapped access to persistent databases, generational garbage collectors, stack overflow handlers, and distributed shared memory."
VERSION=2.12


cd $SOURCE_DIR

wget -nc https://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz
wget -nc ftp://ftp.gnu.org/gnu/libsigsegv/libsigsegv-2.12.tar.gz

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
--disable-static &&
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
