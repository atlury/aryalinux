#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=cdrtools
URL=https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2
DESCRIPTION="The Cdrtools package contains CD recording utilities. These are useful for reading, creating or writing (burning) CDs, DVDs, and Blu-ray discs."
VERSION=3.02a09


cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/cdrtools/cdrtools-3.02a09.tar.bz2

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

export GMAKE_NOWARN=true &&
make -j1 INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
export GMAKE_NOWARN=true &&
make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root install &&
install -v -m755 -d /usr/share/doc/cdrtools-3.02a09 &&
install -v -m644 README* ABOUT doc/*.ps \
/usr/share/doc/cdrtools-3.02a09
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
