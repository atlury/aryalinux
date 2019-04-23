#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnutls
URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.7.tar.xz
DESCRIPTION="The GnuTLS package contains libraries and userspace tools which provide a secure layer over a reliable transport layer. Currently the GnuTLS library implements the proposed standards by the IETF's TLS working group. Quoting from the TLS protocol specification:"
VERSION=3.6.7

#REQ:nettle
#REC:make-ca
#REC:libunistring
#REC:libtasn1
#REC:p11-kit

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.7.tar.xz

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
--disable-guile \
--with-default-trust-store-pkcs11="pkcs11:" &&
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
make -C doc/reference install-data-local
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
