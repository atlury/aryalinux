#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=polkit-gnome
URL=http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz
DESCRIPTION="The Polkit GNOME package provides an Authentication Agent for Polkit that integrates well with the GNOME Desktop environment."
VERSION=0.105

#REQ:gtk3
#REQ:polkit

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/polkit-gnome/0.105/polkit-gnome-0.105.tar.xz

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

./configure --prefix=/usr &&
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
mkdir -p /etc/xdg/autostart &&
cat > /etc/xdg/autostart/polkit-gnome-authentication-agent-1.desktop << "EOF"
[Desktop Entry]
Name=PolicyKit Authentication Agent
Comment=PolicyKit Authentication Agent
Exec=/usr/libexec/polkit-gnome-authentication-agent-1
Terminal=false
Type=Application
Categories=NoDisplay=true
OnlyShowIn=GNOME;XFCE;Unity;
AutostartCondition=GNOME3 unless-session gnome
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
