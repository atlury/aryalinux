#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=usb_modeswitch
URL=
DESCRIPTION="USB Modeswitch helps the USB modems to be recognized by the Linux System by altering Device and Vendor ID for devices that do not get detected as modems by default."
VERSION=2.2.5


cd $SOURCE_DIR

wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-2.2.5.tar.bz2
wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-data-20150627.tar.bz2

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
