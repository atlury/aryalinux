#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gpgme
URL=https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2
DESCRIPTION="The GPGME package is a C library that allows cryptography support to be added to a program. It is designed to make access to public key crypto engines like GnuPG or GpgSM easier for applications. GPGME provides a high-level crypto API for encryption, decryption, signing, signature verification and key management."
VERSION=1.13.0

#REQ:libassuan

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.13.0.tar.bz2

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

./configure --prefix=/usr --disable-gpg-test &&
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
