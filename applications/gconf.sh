#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:dbus-glib
#REQ:libxml2
#REC:gobject-introspection
#REC:gtk3
#REC:polkit
#OPT:gtk-doc
#OPT:openldap

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz

NAME=gconf
VERSION=3.2.6
URL=http://ftp.gnome.org/pub/gnome/sources/GConf/3.2/GConf-3.2.6.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-orbit \
--disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install &&
ln -s gconf.xml.defaults /etc/gconf/gconf.xml.system
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
