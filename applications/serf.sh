#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=serf
URL=https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2
DESCRIPTION="The Serf package contains a C-based HTTP client library built upon the Apache Portable Runtime (APR) library. It multiplexes connections, running the read/write communication asynchronously. Memory copies and transformations are kept to a minimum to provide high performance operation."
VERSION=1.3.9

#REQ:apr-util
#REQ:scons

cd $SOURCE_DIR

wget -nc https://archive.apache.org/dist/serf/serf-1.3.9.tar.bz2

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

sed -i "/Append/s:RPATH=libdir,::" SConstruct &&
sed -i "/Default/s:lib_static,::" SConstruct &&
sed -i "/Alias/s:install_static,::" SConstruct &&
sed -i "/ print/{s/print/print(/; s/$/)/}" SConstruct &&
sed -i "/get_contents()/s/,/.decode()&/" SConstruct &&

scons PREFIX=/usr

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
scons PREFIX=/usr install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
