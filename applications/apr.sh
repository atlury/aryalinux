#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=apr
URL=https://archive.apache.org/dist/apr/apr-1.6.5.tar.bz2
DESCRIPTION="The Apache Portable Runtime (APR) is a supporting library for the Apache web server. It provides a set of application programming interfaces (APIs) that map to the underlying Operating System (OS). Where the OS doesn't support a particular function, APR will provide an emulation. Thus programmers can use the APR to make a program portable across different platforms."
VERSION=1.6.5


cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/apr/apr-1.6.5.tar.bz2
wget -nc ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-1.6.5.tar.bz2

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
--with-installbuilddir=/usr/share/apr-1/build &&
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
