#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:cryptsetup
#REQ:glib2
#REQ:gpgme
#REQ:nss
#REQ:python2
#REQ:swig

cd $SOURCE_DIR

wget -nc https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz

NAME=volume_key
VERSION=0.3.12
URL=https://github.com/felixonmars/volume_key/archive/volume_key-0.3.12.tar.gz

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

autoreconf -fiv &&
./configure --prefix=/usr &&
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
