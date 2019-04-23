#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=remmina
URL=https://github.com/FreeRDP/Remmina/archive/next.zip
DESCRIPTION="Remmina is a remote desktop client written in GTK+, aiming to be useful for system administrators and travellers, who need to work with lots of remote computers in front of either large monitors or tiny netbooks."
VERSION=SVN

#REQ:avahi
#REQ:libssh
#REQ:libvncserver
#REQ:free-rdp
#REQ:gnome-keyring
#REQ:pulseaudio
#REQ:vte
#REQ:cmake
#REQ:git
#REQ:webkitgtk

cd $SOURCE_DIR


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



# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
