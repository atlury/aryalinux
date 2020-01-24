#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:gobject-introspection
#REQ:libgcrypt
#REQ:vala
#REQ:gnome-keyring


cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.8.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.8.tar.xz


NAME=libsecret
VERSION=0.18.8
URL=http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.8.tar.xz
SECTION="Gnome"
DESCRIPTION="The libsecret package contains a GObject based library for accessing the Secret Service API."

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


./configure --prefix=/usr --disable-static &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

