#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=gnupg
URL=https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.15.tar.bz2
DESCRIPTION="The GnuPG package is GNU's tool for secure communication and data storage. It can be used to encrypt data and to create digital signatures. It includes an advanced key management facility and is compliant with the proposed OpenPGP Internet standard as described in RFC2440 and the S/MIME standard as described by several RFCs. GnuPG 2 is the stable version of GnuPG integrating support for OpenPGP and S/MIME."
VERSION=2.2.15

#REQ:libassuan
#REQ:libgcrypt
#REQ:libgpg-error
#REQ:libksba
#REQ:npth
#REC:pinentry

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.15.tar.bz2
wget -nc ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.2.15.tar.bz2

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

sed -e '/noinst_SCRIPTS = gpg-zip/c sbin_SCRIPTS += gpg-zip' \
-i tools/Makefile.in
./configure --prefix=/usr \
--enable-symcryptrun \
--docdir=/usr/share/doc/gnupg-2.2.15 &&
make &&

makeinfo --html --no-split -o doc/gnupg_nochunks.html doc/gnupg.texi &&
makeinfo --plaintext -o doc/gnupg.txt doc/gnupg.texi

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755 -d /usr/share/doc/gnupg-2.2.15/html &&
install -v -m644 doc/gnupg_nochunks.html \
/usr/share/doc/gnupg-2.2.15/html/gnupg.html &&
install -v -m644 doc/*.texi doc/gnupg.txt \
/usr/share/doc/gnupg-2.2.15
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
