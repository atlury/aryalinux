#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libstatgrab
URL=http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz
DESCRIPTION="This is a library that provides cross platform access to statistics about the system on which it's run. It's written in C and presents a selection of useful interfaces which can be used to access key system statistics. The current list of statistics includes CPU usage, memory utilisation, disk usage, process counts, network traffic, disk I/O, and more."
VERSION=0.91


cd $SOURCE_DIR

wget -nc http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz
wget -nc ftp://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/libstatgrab-0.91.tar.gz

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
--docdir=/usr/share/doc/libstatgrab-0.91 &&
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
