#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=wicd
URL=https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz
DESCRIPTION="Wicd is a network manager written in Python. It simplifies network setup by automatically detecting and connecting to wireless and wired networks. Wicd includes support for WPA authentication and DHCP configuration. It provides Curses- and GTK-based graphical frontends for user-friendly control. An excellent KDE-based frontend is also available <a class=\ulink\ href=\http://projects.kde.org/projects/extragear/network/wicd-kde\>http://projects.kde.org/projects/extragear/network/wicd-kde</a>."
VERSION=1.7.4

#REQ:python2
#REQ:dbus-python
#REQ:wireless_tools
#REQ:net-tools
#REC:pygtk
#REC:wpa_supplicant
#REC:dhcpcd
#REC:dhcp

cd $SOURCE_DIR

wget -nc https://launchpad.net/wicd/1.7/1.7.4/+download/wicd-1.7.4.tar.gz

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

sed -e "/detection failed/ a\ self.init='init/default/wicd'" \
-i.orig setup.py &&

rm po/*.po &&

python setup.py configure --no-install-kde \
--no-install-acpi \
--no-install-pmutils \
--no-install-init \
--no-install-gnome-shell-extensions \
--docdir=/usr/share/doc/wicd-1.7.4

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
python setup.py install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
systemctl enable wicd
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
