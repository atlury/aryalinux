#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxqt-build-tools
URL=https://github.com/lxde/lxqt-build-tools/releases/download/0.4.0/lxqt-build-tools-0.4.0.tar.xz
DESCRIPTION="The lxqt-build-tools package provides several tools needed to build LXQt itself as well as other components maintained by the LXQt project."
VERSION=0.4.0

#REQ:cmake
#REQ:qt5

cd $SOURCE_DIR

wget -nc https://github.com/lxde/lxqt-build-tools/releases/download/0.4.0/lxqt-build-tools-0.4.0.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-build-tools/lxqt-build-tools-0.4.0.tar.xz

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

mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
