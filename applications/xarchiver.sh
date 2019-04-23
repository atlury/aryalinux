#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=xarchiver
URL=https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2
DESCRIPTION="XArchiver is a GTK+ archive manager with support for tar, xz, bzip2, gzip, zip, 7z, rar, lzo and many other archive formats."
VERSION=0.5.4

#REQ:gtk2
#REQ:gtk3

cd $SOURCE_DIR

wget -nc https://downloads.sourceforge.net/xarchiver/xarchiver-0.5.4.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/xarchiver-0.5.4-fixes-1.patch

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

patch -Np1 -i ../xarchiver-0.5.4-fixes-1.patch &&

./autogen.sh --prefix=/usr \
--libexecdir=/usr/lib/xfce4 \
--disable-gtk3 \
--docdir=/usr/share/doc/xarchiver-0.5.4 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make DOCDIR=/usr/share/doc/xarchiver-0.5.4 install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
update-desktop-database &&
gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
