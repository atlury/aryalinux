#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libdrm
URL=https://dri.freedesktop.org/libdrm/libdrm-2.4.97.tar.bz2
DESCRIPTION="libdrm provides a user space library for accessing the DRM, direct rendering manager, on operating systems that support the ioctl interface. libdrm is a low-level library, typically used by graphics drivers such as the Mesa DRI drivers, the X drivers, libva and similar projects."
VERSION=2.4.97

#REC:x7lib

cd $SOURCE_DIR

wget -nc https://dri.freedesktop.org/libdrm/libdrm-2.4.97.tar.bz2

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

export XORG_PREFIX=/usr

mkdir build &&
cd build &&

meson --prefix=$XORG_PREFIX -Dudev=true &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
