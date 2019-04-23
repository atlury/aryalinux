#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=alpine
URL=http://anduin.linuxfromscratch.org/BLFS/alpine/alpine-2.21.tar.xz
DESCRIPTION="Alpine is a text-based email client developed by the University of Washington."
VERSION=2.21


cd $SOURCE_DIR

wget -nc http://anduin.linuxfromscratch.org/BLFS/alpine/alpine-2.21.tar.xz

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

LIBS+="-lcrypto" ./configure --prefix=/usr \
--sysconfdir=/etc \
--without-ldap \
--without-krb5 \
--without-pam \
--without-tcl \
--with-ssl-dir=/usr \
--with-passfile=.pine-passfile &&
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
