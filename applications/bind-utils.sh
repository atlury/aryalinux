#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=bind-utils
URL=ftp://ftp.isc.org/isc/bind9/9.14.0/bind-9.14.0.tar.gz
DESCRIPTION="BIND Utilities is not a separate package, it is a collection of the client side programs that are included with <a class=\xref\ href=\../server/bind.html\ title=\BIND-9.13.0\>BIND-9.13.0</a>. The BIND package includes the client side programs <span class=\command\><strong>nslookup</strong>, <span class=\command\><strong>dig</strong> and <span class=\command\><strong>host</strong>. If you install BIND server, these programs will be installed automatically. This section is for those users who don't need the complete BIND server, but need these client side applications."
VERSION=9.14.0


cd $SOURCE_DIR

wget -nc ftp://ftp.isc.org/isc/bind9/9.14.0/bind-9.14.0.tar.gz

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

./configure --prefix=/usr --without-python &&
make -C lib/dns &&
make -C lib/isc &&
make -C lib/bind9 &&
make -C lib/isccfg &&
make -C lib/irs &&
make -C bin/dig

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C bin/dig install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
