#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=sqlite
URL=https://sqlite.org/2019/sqlite-autoconf-3270200.tar.gz
DESCRIPTION="The SQLite package is a software library that implements a self-contained, serverless, zero-configuration, transactional SQL database engine."
VERSION=3270200


cd $SOURCE_DIR

wget -nc https://sqlite.org/2019/sqlite-autoconf-3270200.tar.gz
wget -nc https://sqlite.org/2019/sqlite-doc-3270200.zip

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

unzip -q ../sqlite-doc-3270200.zip
./configure --prefix=/usr \
--disable-static \
--enable-fts5 \
CFLAGS="-g -O2 \
-DSQLITE_ENABLE_FTS3=1 \
-DSQLITE_ENABLE_FTS4=1 \
-DSQLITE_ENABLE_COLUMN_METADATA=1 \
-DSQLITE_ENABLE_UNLOCK_NOTIFY=1 \
-DSQLITE_ENABLE_DBSTAT_VTAB=1 \
-DSQLITE_SECURE_DELETE=1 \
-DSQLITE_ENABLE_FTS3_TOKENIZER=1" &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/sqlite-3.27.2 &&
cp -v -R sqlite-doc-3270200/* /usr/share/doc/sqlite-3.27.2
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
