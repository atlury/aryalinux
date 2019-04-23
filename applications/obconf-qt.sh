#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=obconf-qt
URL=https://github.com/lxde/obconf-qt/releases/download/0.12.0/obconf-qt-0.12.0.tar.xz
DESCRIPTION="The obconf-qt package is an OpenBox Qt based configuration tool."
VERSION=0.12.0

#REQ:gtk2
#REQ:hicolor-icon-theme
#REQ:liblxqt
#REQ:openbox
#OPT:git
#OPT:lxqt-l10n

cd $SOURCE_DIR

wget -nc https://github.com/lxde/obconf-qt/releases/download/0.12.0/obconf-qt-0.12.0.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/obconf-qt/obconf-qt-0.12.0.tar.xz

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
cmake -DCMAKE_BUILD_TYPE=Release          \
      -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DPULL_TRANSLATIONS=no              \
      ..       &&
make "-j`nproc`" || make



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
make install

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh



sudo tee rootscript.sh << "ENDOFROOTSCRIPT"
if [ "$LXQT_PREFIX" != /usr ]; then
  ln -svf $LXQT_PREFIX/share/applications/obconf-qt.desktop \
          /usr/share/applications
fi

ENDOFROOTSCRIPT
sudo chmod 755 rootscript.sh
sudo bash -e ./rootscript.sh
sudo rm rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
