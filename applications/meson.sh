#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=meson
URL=https://github.com/mesonbuild/meson/releases/download/0.50.0/meson-0.50.0.tar.gz
DESCRIPTION="Meson is a project to create the best possible next-generation build system."
VERSION=0.50.0


cd $SOURCE_DIR

wget -nc https://github.com/mesonbuild/meson/releases/download/0.50.0/meson-0.50.0.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/meson-0.50.0-gnome.patch
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/meson-0.50.0-gnome-1.patch

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

patch -Np1 -i ../meson-0.50.0-gnome-1.patch
patch -Np1 -i ../meson-0.50.0-gnome.patch
python3 setup.py build
python3 setup.py install --root=dest
sudo cp -rv dest/* /

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
