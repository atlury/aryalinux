#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=file-roller
URL=http://ftp.acc.umu.se/pub/gnome/sources/file-roller/3.32/file-roller-3.32.0.tar.xz
DESCRIPTION="File Roller is an archive manager for GNOME with support for tar, bzip2, gzip, zip, jar, compress, lzop and many other archive formats."
VERSION=3.32.0

#REQ:gtk3
#REQ:itstool
#REC:cpio
#REC:desktop-file-utils
#REC:json-glib
#REC:libarchive
#REC:libnotify
#REC:nautilus

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/file-roller/3.32/file-roller-3.32.0.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr -Dpackagekit=false .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
chmod -v 0755 /usr/libexec/file-roller/isoinfo.sh &&
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
