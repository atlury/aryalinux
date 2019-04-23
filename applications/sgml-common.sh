#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=sgml-common
URL=https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
DESCRIPTION="The SGML Common package contains <span class=\command\><strong>install-catalog</strong>. This is useful for creating and maintaining centralized SGML catalogs."
VERSION=0.6.3


cd $SOURCE_DIR

wget -nc https://sourceware.org/ftp/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget -nc ftp://sourceware.org/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/sgml-common-0.6.3-manpage-1.patch

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

patch -Np1 -i ../sgml-common-0.6.3-manpage-1.patch &&
autoreconf -f -i
./configure --prefix=/usr --sysconfdir=/etc &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc install &&

install-catalog --add /etc/sgml/sgml-ent.cat \
/usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --add /etc/sgml/sgml-docbook.cat \
/etc/sgml/sgml-ent.cat
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

install-catalog --remove /etc/sgml/sgml-ent.cat \
/usr/share/sgml/sgml-iso-entities-8879.1986/catalog &&

install-catalog --remove /etc/sgml/sgml-docbook.cat \
/etc/sgml/sgml-ent.cat

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
