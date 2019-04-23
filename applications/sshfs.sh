#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=sshfs
URL=https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.1/sshfs-3.5.1.tar.xz
DESCRIPTION="The Sshfs package contains a filesystem client based on the SSH File Transfer Protocol. This is useful for mounting a remote computer that you have ssh access to as a local filesystem. This allows you to drag and drop files or run shell commands on the remote files as if they were on your local computer."
VERSION=3.5.1

#REQ:fuse
#REQ:glib2
#REQ:openssh

cd $SOURCE_DIR

wget -nc https://github.com/libfuse/sshfs/releases/download/sshfs-3.5.1/sshfs-3.5.1.tar.xz

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

mkdir build &&
cd build &&

meson --prefix=/usr .. &&
ninja

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sshfs example.com:/home/userid ~/examplepath
fusermount3 -u ~/example

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
