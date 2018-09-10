#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="simple-scan"
VERSION=3.29.92
DESCRIPTION="Simple Scan — a GNOME document scanning application. Simple Scan allows you to capture images using image scanners (e.g. flatbed scanners) that have suitable SANE drivers installed"

#REQ:packagekit
#REQ:sane
#REQ:itstool

cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/simple-scan-3.29.92.tar.xz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

mkdir build &&
cd    build &&
meson --prefix=/usr         \
      --sysconfdir=/etc     \
      --localstatedir=/var &&
ninja
sudo ninja install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
