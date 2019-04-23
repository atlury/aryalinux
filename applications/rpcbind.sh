#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rpcbind
URL=https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.5.tar.bz2
DESCRIPTION="The rpcbind program is a replacement for portmap. It is required for import or export of Network File System (NFS) shared directories."
VERSION=1.2.5

#REQ:libtirpc

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.5.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/rpcbind-1.2.5-vulnerability_fixes-1.patch
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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
groupadd -g 28 rpc &&
useradd -c "RPC Bind Daemon Owner" -d /dev/null -g rpc \
-s /bin/false -u 28 rpc
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c
patch -Np1 -i ../rpcbind-1.2.5-vulnerability_fixes-1.patch &&

./configure --prefix=/usr \
--bindir=/sbin \
--sbindir=/sbin \
--enable-warmstarts \
--with-rpcuser=rpc &&
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
sudo make install-rpcbind
popd
popd
sudo rm -rf $SOURCE_DIR/blfs-systemd-units-20180105

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
