#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=db
URL=http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz
DESCRIPTION="The Berkeley DB package contains programs and utilities used by many other applications for database related functions."
VERSION=5.3.28


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/bdb/db-5.3.28.tar.gz

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

sed -i 's/\(__atomic_compare_exchange\)/\1_db/' src/dbinc/atomic.h
cd build_unix &&
../dist/configure --prefix=/usr \
--enable-compat185 \
--enable-dbm \
--disable-static \
--enable-cxx &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/db-5.3.28 install &&

chown -v -R root:root \
/usr/bin/db_* \
/usr/include/db{,_185,_cxx}.h \
/usr/lib/libdb*.{so,la} \
/usr/share/doc/db-5.3.28
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
