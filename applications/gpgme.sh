#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:libassuan
#OPT:doxygen
#OPT:gnupg
#OPT:clisp
#OPT:python2
#OPT:qt5
#OPT:swig

cd $SOURCE_DIR

wget -nc https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.12.0.tar.bz2

NAME=gpgme
VERSION=1.12.0.
URL=https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.12.0.tar.bz2

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

./configure --prefix=/usr --disable-gpg-test &&
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
