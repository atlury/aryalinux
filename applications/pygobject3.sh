#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=pygobject3
URL=http://ftp.gnome.org/pub/gnome/sources/pygobject/3.32/pygobject-3.32.0.tar.xz
DESCRIPTION=""
VERSION=3.32.0

#REQ:gobject-introspection
#REQ:pycairo
#REC:python2
#REC:pycairo

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/pygobject/3.32/pygobject-3.32.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/pygobject/3.32/pygobject-3.32.0.tar.xz

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

mkdir python2 &&
pushd python2 &&
meson --prefix=/usr -Dpython=python2 &&
ninja &&
popd
mkdir python3 &&
pushd python3 &&
meson --prefix=/usr -Dpython=python3 &&
ninja &&
popd

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja -C python2 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja -C python3 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
