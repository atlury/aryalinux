#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=evolution
URL=http://ftp.acc.umu.se/pub/gnome/sources/evolution/3.32/evolution-3.32.0.tar.xz
DESCRIPTION="The Evolution package contains an integrated mail, calendar and address book suite designed for the GNOME environment."
VERSION=3.32.0

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gnome-autoar
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk
#REC:bogofilter
#REC:enchant
#REC:gnome-desktop
#REC:highlight
#REC:libcanberra
#REC:libgweather
#REC:libnotify
#REC:openldap
#REC:seahorse

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/evolution/3.32/evolution-3.32.0.tar.xz

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

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DSYSCONF_INSTALL_DIR=/etc \
-DENABLE_INSTALLED_TESTS=ON \
-DENABLE_PST_IMPORT=OFF \
-DENABLE_GTKSPELL=OFF \
-DENABLE_YTNEF=OFF \
-DENABLE_CONTACT_MAPS=OFF \
-G Ninja .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
