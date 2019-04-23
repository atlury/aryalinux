#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxqt-kidletime
URL=http://download.kde.org/stable/frameworks/5.46/kidletime-5.46.0.tar.xz
DESCRIPTION="KIdleTime is used to report idle time of user and system. It is useful not only for finding out about the current idle time of the PC, but also for getting notified upon idle time events, such as custom timeouts, or user activity."
VERSION=5.46.0

#REQ:extra-cmake-modules

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.46/kidletime-5.46.0.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/kidletime/kidletime-5.46.0.tar.xz

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
      -DCMAKE_BUILD_TYPE=Release          \
      -DBUILD_TESTING=OFF                 \
      -Wno-dev ..                         &&
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
