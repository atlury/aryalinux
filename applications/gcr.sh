#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gcr
URL=http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.1.tar.xz
DESCRIPTION="The Gcr package contains libraries used for displaying certificates and accessing key stores. It also provides the viewer for crypto files on the GNOME Desktop."
VERSION=3.28.1

#REQ:glib2
#REQ:libgcrypt
#REQ:libtasn1
#REQ:p11-kit
#REC:gnupg
#REC:gobject-introspection
#REC:gtk3
#REC:libxslt
#REC:vala

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.1.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/gcr/3.28/gcr-3.28.1.tar.xz

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

sed -i -r 's:"(/desktop):"/org/gnome\1:' schema/*.xml &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--without-gtk-doc &&
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
