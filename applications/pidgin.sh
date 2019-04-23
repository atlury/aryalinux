#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=pidgin
URL=https://downloads.sourceforge.net/pidgin/pidgin-2.13.0.tar.bz2
DESCRIPTION="Pidgin is a Gtk+ 2 instant messaging client that can connect with a wide range of networks including AIM, ICQ, GroupWise, MSN, Jabber, IRC, Napster, Gadu-Gadu, SILC, Zephyr and Yahoo!"
VERSION=2.13.0

#REQ:gtk2
#REC:libgcrypt
#REC:gstreamer10
#REC:gnutls
#REC:nss

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/pidgin/pidgin-2.13.0.tar.bz2

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

./configure --prefix=/usr \
--sysconfdir=/etc \
--with-gstreamer=1.0 \
--disable-avahi \
--disable-gtkspell \
--disable-meanwhile \
--disable-idn \
--disable-nm \
--disable-vv \
--disable-tcl &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
mkdir -pv /usr/share/doc/pidgin-2.13.0 &&
cp -v README doc/gtkrc-2.0 /usr/share/doc/pidgin-2.13.0
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -pv /usr/share/doc/pidgin-2.13.0/api &&
cp -v doc/html/* /usr/share/doc/pidgin-2.13.0/api
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
gtk-update-icon-cache &&
update-desktop-database
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
