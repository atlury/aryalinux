#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libisoburn
URL=http://files.libburnia-project.org/releases/libisoburn-1.5.0.tar.gz
DESCRIPTION="libisoburn is a frontend for libraries libburn and libisofs which enables creation and expansion of ISO-9660 filesystems on all CD/DVD/BD media supported by libburn. This includes media like DVD+RW, which do not support multi-session management on media level and even plain disk files or block devices."
VERSION=1.5.0

#REQ:libburn
#REQ:libisofs

cd $SOURCE_DIR

wget -nc http://files.libburnia-project.org/releases/libisoburn-1.5.0.tar.gz

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
--enable-pkg-check-modules &&
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
