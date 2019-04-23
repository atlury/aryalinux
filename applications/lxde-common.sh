#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lxde-common
URL=https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz
DESCRIPTION="The LXDE Common package provides a set of default configuration for LXDE."
VERSION=0.99.2

#REQ:lxde-icon-theme
#REQ:lxpanel
#REQ:lxsession
#REQ:openbox
#REQ:pcmanfm
#REC:desktop-file-utils
#REC:hicolor-icon-theme
#REC:shared-mime-info
#REC:dbus

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/lxde/lxde-common-0.99.2.tar.xz

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

./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
update-mime-database /usr/share/mime &&
gtk-update-icon-cache -qf /usr/share/icons/hicolor &&
update-desktop-database -q
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.xinitrc << "EOF"
# No need to run dbus-launch, since it is run by startlxde
startlxde
EOF

startx
startx &> ~/.x-session-errors

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
