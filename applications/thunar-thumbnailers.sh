#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=thunar-thumbnailers
URL=https://git.xfce.org/apps/thunar-thumbnailers/snapshot/thunar-thumbnailers-0.4.1.tar.bz2
DESCRIPTION="Thunar uses external utilities - so called thumbnailers - to generate previews of certain files. Thunar ships with thumbnailers to generate previews of image and font files and can automatically use available GNOME thumbnailers if it was build with support for gconf."
VERSION=0.4.1

#REQ:thunar
#REQ:xfce4-dev-tools

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
