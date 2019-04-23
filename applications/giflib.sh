#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=giflib
URL=https://sourceforge.net/projects/giflib/files/giflib-5.1.9.tar.gz
DESCRIPTION="The giflib package contains libraries for reading and writing GIFs as well as programs for converting and working with GIF files."
VERSION=5.1.9

#REQ:xmlto

cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/giflib/files/giflib-5.1.9.tar.gz

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

make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PREFIX=/usr install &&
rm -vf /usr/lib/libgif.a &&

find doc \( -name Makefile\* -o -name \*.1 \
-o -name \*.xml \) -exec rm -v {} \; &&

install -v -dm755 /usr/share/doc/giflib-5.1.9 &&
cp -v -R doc/* /usr/share/doc/giflib-5.1.9
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
