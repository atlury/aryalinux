#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=fuse2
URL=https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz
DESCRIPTION="FUSE (Filesystem in Userspace) is a simple interface for userspace programs to export a virtual filesystem to the Linux kernel. Fuse also aims to provide a secure method for non privileged users to create and mount their own filesystem implementations."
VERSION=2.9.7


cd $SOURCE_DIR

wget -nc https://github.com/libfuse/libfuse/releases/download/fuse-2.9.7/fuse-2.9.7.tar.gz

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

./configure --prefix=/usr \
--disable-static \
--exec-prefix=/ &&

make &&
make DESTDIR=$PWD/Dest install

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -vm755 Dest/lib/libfuse.so.2.9.7 /lib &&
install -vm755 Dest/lib/libulockmgr.so.1.0.1 /lib &&
ln -sfv ../../lib/libfuse.so.2.9.7 /usr/lib/libfuse.so &&
ln -sfv ../../lib/libulockmgr.so.1.0.1 /usr/lib/libulockmgr.so &&

install -vm644 Dest/lib/pkgconfig/fuse.pc /usr/lib/pkgconfig && 

install -vm4755 Dest/bin/fusermount /bin &&
install -vm755 Dest/bin/ulockmgr_server /bin &&

install -vm755 Dest/sbin/mount.fuse /sbin &&

install -vdm755 /usr/include/fuse &&

install -vm644 Dest/usr/include/*.h /usr/include &&
install -vm644 Dest/usr/include/fuse/*.h /usr/include/fuse/ &&

install -vm644 Dest/usr/share/man/man1/* /usr/share/man/man1 &&
/sbin/ldconfig -v
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
