#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=openldap
URL=ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz
DESCRIPTION="The OpenLDAP package provides an open source implementation of the Lightweight Directory Access Protocol."
VERSION=2.4.47

#REC:cyrus-sasl

cd $SOURCE_DIR

wget -nc ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.47.tgz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/openldap-2.4.47-consolidated-1.patch

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

patch -Np1 -i ../openldap-2.4.47-consolidated-1.patch &&
autoconf &&

./configure --prefix=/usr \
--sysconfdir=/etc \
--disable-static \
--enable-dynamic \
--disable-debug \
--disable-slapd &&

make depend &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install

ln -sf ../lib/slapd /usr/sbin/slapd

ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
