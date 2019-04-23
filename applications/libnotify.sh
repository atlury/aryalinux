#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libnotify
URL=http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz
DESCRIPTION="The libnotify library is used to send desktop notifications to a notification daemon, as defined in the Desktop Notifications spec. These notifications can be used to inform the user about an event or display some form of information without getting in the user's way."
VERSION=0.7.7

#REQ:gtk3

cd $SOURCE_DIR

wget -nc http://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz
wget -nc ftp://ftp.gnome.org/pub/gnome/sources/libnotify/0.7/libnotify-0.7.7.tar.xz

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

./configure --prefix=/usr --disable-static &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
