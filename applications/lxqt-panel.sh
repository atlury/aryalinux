#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxqt-panel
URL=https://github.com/lxde/lxqt-panel/releases/download/0.12.0/lxqt-panel-0.12.0.tar.xz
DESCRIPTION="The lxqt-panel package contains a lightweight X11 desktop panel."
VERSION=0.12.0

#REQ:lxqt-kguiaddons
#REQ:lxqt-solid
#REQ:lxqt-globalkeys
#REQ:libdbusmenu-qt
#REQ:liblxqt
#REQ:lxmenu-data
#REQ:menu-cache
#REQ:lxqt-l10n
#REC:alsa-lib
#REC:pulseaudio
#REC:libstatgrab
#REC:libsysstat
#REC:libxkbcommon
#REC:lm_sensors
#OPT:git
#OPT:lxqt-l10n

cd $SOURCE_DIR

wget -nc https://github.com/lxde/lxqt-panel/releases/download/0.12.0/lxqt-panel-0.12.0.tar.xz
wget -nc http://mirrors-usa.go-parts.com/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz
wget -nc http://mirrors-ru.go-parts.com/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz
wget -nc ftp://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz
wget -nc http://ftp.lfs-matrix.net/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz
wget -nc ftp://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz
wget -nc http://ftp.osuosl.org/pub/blfs/conglomeration/lxqt-panel/lxqt-panel-0.12.0.tar.xz

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

sed -e 's:<KF5/KWindowSystem/:<:'               \
    -i plugin-taskbar/lxqttaskgroup.{h,cpp}     &&
mkdir -v build &&
cd       build &&
cmake -DCMAKE_INSTALL_PREFIX=$LXQT_PREFIX \
      -DCMAKE_BUILD_TYPE=Release          \
      -DPULL_TRANSLATIONS=no              \
      ..                                  &&
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
