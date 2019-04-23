#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=glib2
URL=http://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.0.tar.xz
DESCRIPTION="The GLib package contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for such runtime functionality as an event loop, threads, dynamic loading and an object system."
VERSION=2.60.0

#REC:libxslt
#REC:pcre
#REC:gobject-introspection

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.0.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/glib/2.60/glib-2.60.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/glib-2.60.0-skip_warnings-1.patch

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

patch -Np1 -i ../glib-2.60.0-skip_warnings-1.patch
mkdir build &&
cd build &&

meson --prefix=/usr \
-Dman=true \
-Dselinux=disabled \
.. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

mkdir -p /usr/share/doc/glib-2.60.0 &&
cp -r ../docs/reference/{NEWS,gio,glib,gobject} /usr/share/doc/glib-2.60.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
