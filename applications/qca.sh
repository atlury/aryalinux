#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:make-ca
#REQ:cmake
#REQ:qt5
#REQ:which
#OPT:cyrus-sasl
#OPT:gnupg
#OPT:libgcrypt
#OPT:libgpg-error
#OPT:nss
#OPT:nspr
#OPT:p11-kit
#OPT:doxygen
#OPT:which

cd $SOURCE_DIR

wget -nc http://download.kde.org/stable/qca/2.1.3/src/qca-2.1.3.tar.xz
wget -nc http://www.linuxfromscratch.org/patches/blfs/svn/qca-2.1.3-openssl-1.patch

NAME=qca
VERSION=2.1.3
URL=http://download.kde.org/stable/qca/2.1.3/src/qca-2.1.3.tar.xz

if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

patch -Np1 -i ../qca-2.1.3-openssl-1.patch
sed -i 's@cert.pem@certs/ca-bundle.crt@' CMakeLists.txt
mkdir build &&
cd build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
-DCMAKE_BUILD_TYPE=Release \
-DQCA_MAN_INSTALL_DIR:PATH=/usr/share/man \
.. &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"EOF"
make install
EOF
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
