#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME=rep-gtk
URL=http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz
DESCRIPTION="The rep-gtk package contains a Lisp and GTK binding. This is useful for extending GTK-2 and GDK libraries with Lisp. Starting at rep-gtk-0.15, the package contains the bindings to GTK and uses the same instructions. Both can be installed, if needed."
VERSION=gtk_0.90.8.3

#REQ:gtk2
#REQ:librep

cd $SOURCE_DIR

wget -nc http://download.tuxfamily.org/librep/rep-gtk/rep-gtk_0.90.8.3.tar.xz

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

./autogen.sh --prefix=/usr &&
make

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT
chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

# BUILD COMMANDS END HERE

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi
register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"
