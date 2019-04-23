#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=dhcpcd
URL=http://roy.marples.name/downloads/dhcpcd/dhcpcd-7.1.1.tar.xz
DESCRIPTION="dhcpcd is an implementation of the DHCP client specified in RFC2131. A DHCP client is useful for connecting your computer to a network which uses DHCP to assign network addresses. dhcpcd strives to be a fully featured, yet very lightweight DHCP client."
VERSION=7.1.1


cd $SOURCE_DIR

wget -nc http://roy.marples.name/downloads/dhcpcd/dhcpcd-7.1.1.tar.xz
wget -nc ftp://roy.marples.name/pub/dhcpcd/dhcpcd-7.1.1.tar.xz
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2

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

./configure --libexecdir=/lib/dhcpcd \
--dbdir=/var/lib/dhcpcd &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/svn/blfs-systemd-units-20180105.tar.bz2
tar -xf blfs-systemd-units-20180105.tar.bz2
pushd blfs-systemd-units-20180105
sudo make install-dhcpcd
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
