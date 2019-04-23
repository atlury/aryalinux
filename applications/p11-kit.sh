#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=p11-kit
URL=https://github.com/p11-glue/p11-kit/releases/download/0.23.15/p11-kit-0.23.15.tar.gz
DESCRIPTION="The p11-kit package provides a way to load and enumerate PKCS #11 (a Cryptographic Token Interface Standard) modules."
VERSION=0.23.15

#REC:libtasn1

cd $SOURCE_DIR

wget -nc https://github.com/p11-glue/p11-kit/releases/download/0.23.15/p11-kit-0.23.15.tar.gz

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

sed '20,$ d' -i trust/trust-extract-compat.in &&
cat >> trust/trust-extract-compat.in << "EOF"
# Copy existing anchor modifications to /etc/ssl/local
/usr/libexec/make-ca/copy-trust-modifications

# Generate a new trust store
/usr/sbin/make-ca -f -g
EOF
./configure --prefix=/usr \
--sysconfdir=/etc \
--with-trust-paths=/etc/pki/anchors &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
ln -sf /usr/libexec/p11-kit/trust-extract-compat \
/usr/bin/update-ca-certificates
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -sfv ./pkcs11/p11-kit-trust.so /usr/lib/libnssckbi.so
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
