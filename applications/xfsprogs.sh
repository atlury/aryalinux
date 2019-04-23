#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfsprogs
URL=https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.20.0.tar.xz
DESCRIPTION="The xfsprogs package contains administration and debugging tools for the XFS file system."
VERSION=4.20.0


cd $SOURCE_DIR

wget -nc https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-4.20.0.tar.xz

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

make DEBUG=-DNDEBUG \
INSTALL_USER=root \
INSTALL_GROUP=root \
LOCAL_CONFIGURE_OPTIONS="--enable-readline"

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-4.20.0 install &&
make PKG_DOC_DIR=/usr/share/doc/xfsprogs-4.20.0 install-dev &&

rm -rfv /usr/lib/libhandle.a &&
rm -rfv /lib/libhandle.{a,la,so} &&
ln -sfv ../../lib/libhandle.so.1 /usr/lib/libhandle.so &&
sed -i "s@libdir='/lib@libdir='/usr/lib@" /usr/lib/libhandle.la
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
