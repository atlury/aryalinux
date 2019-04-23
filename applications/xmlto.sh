#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xmlto
URL=https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2
DESCRIPTION="The xmlto package is a front-end to a XSL toolchain. It chooses an appropriate stylesheet for the conversion you want and applies it using an external XSLT processor. It also performs any necessary post-processing."
VERSION=0.0.28

#REQ:docbook
#REQ:docbook-xsl
#REQ:libxslt

cd $SOURCE_DIR

wget -nc https://releases.pagure.org/xmlto/xmlto-0.0.28.tar.bz2

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

LINKS="/usr/bin/links" \
./configure --prefix=/usr &&

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
