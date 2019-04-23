#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=fontconfig
URL=https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2
DESCRIPTION="The Fontconfig package contains a library and support programs used for configuring and customizing font access."
VERSION=2.13.1

#REQ:freetype2

cd $SOURCE_DIR

wget -nc https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2

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

rm -f src/fcobjshash.h
./configure --prefix=/usr \
--sysconfdir=/etc \
--localstatedir=/var \
--disable-docs \
--docdir=/usr/share/doc/fontconfig-2.13.1 &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 \
/usr/share/{man/man{1,3,5},doc/fontconfig-2.13.1/fontconfig-devel} &&
install -v -m644 fc-*/*.1 /usr/share/man/man1 &&
install -v -m644 doc/*.3 /usr/share/man/man3 &&
install -v -m644 doc/fonts-conf.5 /usr/share/man/man5 &&
install -v -m644 doc/fontconfig-devel/* \
/usr/share/doc/fontconfig-2.13.1/fontconfig-devel &&
install -v -m644 doc/*.{pdf,sgml,txt,html} \
/usr/share/doc/fontconfig-2.13.1
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
