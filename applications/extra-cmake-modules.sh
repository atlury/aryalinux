#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=extra-cmake-modules
URL=http://download.kde.org/stable/frameworks/5.55/extra-cmake-modules-5.55.0.tar.xz
DESCRIPTION="The Extra Cmake Modules package contains extra CMake modules used by KDE Frameworks 5 and other packages."
VERSION=5.55.0

#REQ:cmake

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/frameworks/5.55/extra-cmake-modules-5.55.0.tar.xz

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

sed -i '/"lib64"/s/64//' kde-modules/KDEInstallDirs.cmake &&

mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
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
