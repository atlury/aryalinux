#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=lvm2
URL=https://sourceware.org/ftp/lvm2/LVM2.2.03.02.tgz
DESCRIPTION="The LVM2 package is a set of tools that manage logical partitions. It allows spanning of file systems across multiple physical disks and disk partitions and provides for dynamic growing or shrinking of logical partitions, mirroring and low storage footprint snapshots."
VERSION=LVM2.2.03.02

#REQ:libaio

cd $SOURCE_DIR

wget -nc https://sourceware.org/ftp/lvm2/LVM2.2.03.02.tgz
wget -nc ftp://sourceware.org/pub/lvm2/LVM2.2.03.02.tgz

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

SAVEPATH=$PATH &&
PATH=$PATH:/sbin:/usr/sbin &&
./configure --prefix=/usr \
--exec-prefix= \
--with-confdir=/etc \
--enable-cmdlib \
--enable-pkgconfig \
--enable-udev_sync &&
make &&
PATH=$SAVEPATH &&
unset SAVEPATH

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
