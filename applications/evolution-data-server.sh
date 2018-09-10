#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
DESCRIPTION=" Evolution Data Server package provides a unified backend for programs that work with contacts, tasks, and calendar information. It was originally developed for Evolution (hence the name), but is now used by other packages as well."
SECTION="gnome"
VERSION=3.29.92
NAME="evolution-data-server"

#REQ:db
#REQ:gcr
#REQ:libgdata
#REQ:libical
#REQ:libsecret
#REQ:nss
#REQ:python2
#REQ:sqlite
#REC:gnome-online-accounts
#REC:gobject-introspection
#REC:gtk3
#REC:icu
#REC:libgdata
#REC:libgweather
#REC:vala
#OPT:gtk-doc
#OPT:mitkrb
#OPT:openldap


cd $SOURCE_DIR

URL=https://download.gnome.org/core/3.29/3.29.92/sources/evolution-data-server-3.29.92.tar.xz

if [ ! -z $URL ]
then
wget -nc $URL
wget -nc https://raw.githubusercontent.com/FluidIdeas/patches/1.0/evolution-data-server-3.28.0-icu.patch

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

patch -Np1 -i ../evolution-data-server-3.28.0-icu.patch

mkdir build &&
cd    build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr   \
      -DENABLE_UOA=OFF              \
      -DENABLE_VALA_BINDINGS=ON     \
      -DENABLE_INSTALLED_TESTS=ON   \
      -DENABLE_GOOGLE=ON            \
      -DENABLE_GOOGLE_AUTH=OFF      \
      -DWITH_OPENLDAP=OFF           \
      -DWITH_KRB5=OFF               \
      -DENABLE_INTROSPECTION=ON     \
      -DENABLE_GTK_DOC=OFF          \
      .. &&
make "-j`nproc`" || make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
