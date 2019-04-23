#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=virt-manager
URL=https://virt-manager.org/download/sources/virt-manager/virt-manager-1.4.0.tar.gz
DESCRIPTION="A UI for managing virtual machines for Qemu, VirtualBox, VMWare etc."
VERSION=1.4.0

#REQ:python2
#REQ:gtk3
#REQ:libvirt
#REQ:libvirt-python
#REQ:libvirt-glib
#REQ:python-ipaddr
#REQ:python-requests
#REQ:python-modules#pygobject3
#REQ:libosinfo

cd $SOURCE_DIR

wget -nc $URL

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
