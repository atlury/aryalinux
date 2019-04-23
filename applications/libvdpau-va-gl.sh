#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libvdpau-va-gl
URL=https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz
DESCRIPTION=""
VERSION=0.4.0

#REQ:cmake
#REQ:ffmpeg

cd $SOURCE_DIR

wget -nc https://github.com/i-rinat/libvdpau-va-gl/archive/v0.4.0/libvdpau-va-gl-0.4.0.tar.gz

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

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX .. &&
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
echo "export VDPAU_DRIVER=va_gl" >> /etc/profile.d/xorg.sh
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
