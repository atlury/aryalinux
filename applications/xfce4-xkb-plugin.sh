#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xfce4-xkb-plugin
URL=http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2
DESCRIPTION="If your system has a standard (US) keyboard, you probably do not need to install this plugin."
VERSION=0.7.1

#REQ:librsvg
#REQ:libxklavier
#REQ:xfce4-panel

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/panel-plugins/xfce4-xkb-plugin/0.7/xfce4-xkb-plugin-0.7.1.tar.bz2

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

sed -e 's|xfce4/panel-plugins|xfce4/panel/plugins|' \
-i panel-plugin/{Makefile.in,xkb-plugin.desktop.in.in} &&

./configure --prefix=/usr \
--libexecdir=/usr/lib \
--disable-debug &&

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
