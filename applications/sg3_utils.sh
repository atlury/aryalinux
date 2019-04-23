#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=sg3_utils
URL=http://sg.danny.cz/sg/p/sg3_utils-1.44.tar.xz
DESCRIPTION="The sg3_utils package contains low level utilities for devices that use a SCSI command set. Apart from SCSI parallel interface (SPI) devices, the SCSI command set is used by ATAPI devices (CD/DVDs and tapes), USB mass storage devices, Fibre Channel disks, IEEE 1394 storage devices (that use the \SBP\ protocol), SAS, iSCSI and FCoE devices (amongst others)."
VERSION=1.44


cd $SOURCE_DIR

wget -nc http://sg.danny.cz/sg/p/sg3_utils-1.44.tar.xz

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
