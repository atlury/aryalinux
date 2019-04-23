#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gdm
URL=http://ftp.acc.umu.se/pub/gnome/sources/gdm/3.32/gdm-3.32.0.tar.xz
DESCRIPTION="GDM is a system service that is responsible for providing graphical logins and managing local and remote displays."
VERSION=3.32.0

#REQ:accountsservice
#REQ:gtk3
#REQ:iso-codes
#REQ:itstool
#REQ:keyutils
#REQ:libcanberra
#REQ:libdaemon
#REQ:linux-pam
#REQ:gnome-session
#REQ:gnome-shell
#REQ:systemd

cd $SOURCE_DIR

wget -nc http://ftp.acc.umu.se/pub/gnome/sources/gdm/3.32/gdm-3.32.0.tar.xz

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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 21 gdm &&
useradd -c "GDM Daemon Owner" -d /var/lib/gdm -u 21 \
-g gdm -s /bin/false gdm &&
passwd -ql gdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--without-plymouth \
--disable-static \
--enable-gdm-xsession \
--with-pam-mod-dir=/lib/security &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
install -v -m644 data/gdm.service /lib/systemd/system/gdm.service
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable gdm
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo tee /etc/gdm/custom.conf <<"EOF"
# GDM configuration storage

[daemon]
# Uncomment the line below to force the login screen to use Xorg
#WaylandEnable=false
DefaultSession=gnome-xorg.desktop

[security]

[xdmcp]

[chooser]

[debug]
# Uncomment the line below to turn on debugging
#Enable=true
EOF

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
