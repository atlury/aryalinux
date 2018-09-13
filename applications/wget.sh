#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" The Wget package contains a utility useful for non-interactive downloading of files from the Web."
SECTION="basicnet"
VERSION=1.19.5
NAME="wget"

#REC:make-ca
#OPT:gnutls
#OPT:gpgme
#OPT:libidn2
#OPT:pcre
#OPT:python2
#OPT:valgrind


cd $SOURCE_DIR

URL=https://ftp.gnu.org/gnu/wget/wget-1.19.5.tar.gz

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

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make "-j`nproc`" || make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
