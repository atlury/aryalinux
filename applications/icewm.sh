#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=icewm
URL=https://github.com/bbidulock/icewm/releases/download/1.4.2/icewm-1.4.2.tar.bz2
DESCRIPTION="IceWM is a window manager with the goals of speed, simplicity, and not getting in the user's way."
VERSION=1.4.2

#REQ:gdk-pixbuf

cd $SOURCE_DIR

wget -nc https://github.com/bbidulock/icewm/releases/download/1.4.2/icewm-1.4.2.tar.bz2

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
--docdir=/usr/share/doc/icewm-1.4.2 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm /usr/share/xsessions/icewm.desktop
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

echo icewm-session > ~/.xinitrc
mkdir -v ~/.icewm &&
cp -v /usr/share/icewm/keys ~/.icewm/keys &&
cp -v /usr/share/icewm/menu ~/.icewm/menu &&
cp -v /usr/share/icewm/preferences ~/.icewm/preferences &&
cp -v /usr/share/icewm/toolbar ~/.icewm/toolbar &&
cp -v /usr/share/icewm/winoptions ~/.icewm/winoptions
icewm-menu-fdo >~/.icewm/menu
cat > ~/.icewm/startup << "EOF"
rox -p Default &
EOF &&
chmod +x ~/.icewm/startup

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
