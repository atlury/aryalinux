#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xscreensaver
URL=https://www.jwz.org/xscreensaver/xscreensaver-5.42.tar.gz
DESCRIPTION="The XScreenSaver is a modular screen saver and locker for the X Window System. It is highly customizable and allows the use of any program that can draw on the root window as a display mode. The purpose of XScreenSaver is to display pretty pictures on your screen when it is not in use, in keeping with the philosophy that unattended monitors should always be doing something interesting, just like they do in the movies. However, XScreenSaver can also be used as a screen locker, to prevent others from using your terminal while you are away."
VERSION=5.42

#REQ:libglade
#REQ:x7app
#REC:glu

cd $SOURCE_DIR

wget -nc https://www.jwz.org/xscreensaver/xscreensaver-5.42.tar.gz

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

sed -i '/^\/\//d' hacks/fontglide.c
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
cat > /etc/pam.d/xscreensaver << "EOF"
# Begin /etc/pam.d/xscreensaver

auth include system-auth
account include system-account

# End /etc/pam.d/xscreensaver
EOF
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
