#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfce4-whiskermenu-plugin
URL=https://git.xfce.org/panel-plugins/xfce4-whiskermenu-plugin/snapshot/xfce4-whiskermenu-plugin-2.1.7.tar.gz
DESCRIPTION="The Whisker Menu presents a Windows-Like start menu for XFCE panel"
VERSION=2.1.7

#REQ:cmake
#REC:cmake

cd $SOURCE_DIR


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

mkdir -pv build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr &&
make

sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
