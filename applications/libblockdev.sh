#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=libblockdev
URL=https://github.com/storaged-project/libblockdev/releases/download/2.21-1/libblockdev-2.21.tar.gz
DESCRIPTION="libblockdev is a C library supporting GObject introspection for manipulation of block devices. It has a plugin-based architecture where each technology (like LVM, Btrfs, MD RAID, Swap,...) is implemented in a separate plugin, possibly with multiple implementations (e.g. using LVM CLI or the new LVM DBus API)."
VERSION=2.21

#REQ:gobject-introspection
#REQ:libbytesize
#REQ:parted
#REQ:volume_key
#REQ:yaml

cd $SOURCE_DIR

wget -nc https://github.com/storaged-project/libblockdev/releases/download/2.21-1/libblockdev-2.21.tar.gz

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
--sysconfdir=/etc \
--with-python3 \
--without-gtk-doc \
--without-nvdimm \
--without-dm &&
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
