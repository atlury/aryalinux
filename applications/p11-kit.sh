#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The p11-kit package provides a way to load and enumerate PKCS #11 (a Cryptographic Token Interface Standard) modules."
SECTION="postlfs"
VERSION=0.23.14
NAME="p11-kit"

#REQ:nss
#REC:make-ca
#REC:libtasn1
#OPT:nss
#OPT:gtk-doc
#OPT:libxslt


cd $SOURCE_DIR

URL=https://github.com/p11-glue/p11-kit/releases/download/0.23.14/p11-kit-0.23.14.tar.gz

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

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --with-trust-paths=/etc/pki/anchors &&
make "-j`nproc`" || make
sudo make install
if [ -e /usr/lib/libnssckbi.so ]; then
  sudo readlink /usr/lib/libnssckbi.so ||
  sudo rm -v /usr/lib/libnssckbi.so    &&
  sudo ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
fi


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
