#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

#REQ:glib2
#OPT:curl
#OPT:freetype2
#OPT:gdk-pixbuf
#OPT:gst10-plugins-base
#OPT:gtk-doc
#OPT:libjpeg
#OPT:libpng
#OPT:poppler

cd $SOURCE_DIR

wget -nc http://archive.xfce.org/src/xfce/tumbler/0.2/tumbler-0.2.3.tar.bz2

NAME=tumbler
VERSION=0.2.3.
URL=http://archive.xfce.org/src/xfce/tumbler/0.2/tumbler-0.2.3.tar.bz2

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

./configure --prefix=/usr --sysconfdir=/etc &&
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
