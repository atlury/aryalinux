#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=intel-vaapi-driver
URL=https://github.com/intel/intel-vaapi-driver/releases/download/2.3.0/intel-vaapi-driver-2.3.0.tar.bz2
DESCRIPTION=""
VERSION=2.3.0


cd $SOURCE_DIR

wget -nc https://github.com/intel/intel-vaapi-driver/releases/download/2.3.0/intel-vaapi-driver-2.3.0.tar.bz2

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

export XORG_PREFIX=/usr
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

./configure $XORG_CONFIG &&
make -j$(nproc)
sudo make install

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
