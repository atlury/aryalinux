#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="gnome-documents"
VERSION="3.29.91"
DESCRIPTION="Documents is a document manager application designed to work with GNOME 3. It's included in the default set of core applications since GNOME 3.2"

cd $SOURCE_DIR

URL="https://download.gnome.org/core/3.29/3.29.92/sources/gnome-documents-3.29.91.tar.xz"
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`

tar xf $TARBALL
cd $DIRECTORY

mkdir build
cd build
meson --prefix=/usr &&
make "-j`nproc`"
sudo make install

cd $SOURCE_DIR

cleanup "$NAME" "$DIRECTORY"
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
