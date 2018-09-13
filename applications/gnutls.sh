#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The GnuTLS package contains libraries and userspace tools which provide a secure layer over a reliable transport layer. Currently the GnuTLS library implements the proposed standards by the IETF's TLS working group. Quoting from the TLS protocol specification:"
SECTION="postlfs"
VERSION=3.6.3
NAME="gnutls"

#REQ:nettle
#REC:make-ca
#REC:libunistring
#REC:libtasn1
#REC:p11-kit
#OPT:doxygen
#OPT:gtk-doc
#OPT:guile
#OPT:libidn
#OPT:libidn2
#OPT:net-tools
#OPT:texlive
#OPT:tl-installer
#OPT:unbound
#OPT:valgrind


cd $SOURCE_DIR

URL=https://www.gnupg.org/ftp/gcrypt/gnutls/v3.6/gnutls-3.6.3.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL

TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=`tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$"`
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi
cd $DIRECTORY
fi

whoami > /tmp/currentuser

./configure --prefix=/usr \
            --with-default-trust-store-pkcs11="pkcs11:" &&
make "-j`nproc`" || make
sudo make install
sudo make -C doc/reference install-data-local



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
